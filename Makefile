CROSS_COMPILE ?= arm-none-eabi-
CC = $(CROSS_COMPILE)gcc
CPP = $(CC) -E
AR = $(CROSS_COMPILE)ar
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
SIZE = $(CROSS_COMPILE)size


# target binary name
TARGET := led


# make searching paths
vpath %.s cmsis/startup
vpath %.c cmsis firmware/src hardware/src system/src user/src user
vpath %.h cmsis firmware/inc hardware/inc system/inc user/inc


# macro for STM32
DEFS += STM32F10X_MD
DEFS += USE_STDPERIPH_DRIVER
DEFS := $(addprefix -D, $(DEFS))

# header file paths
INCS += cmsis
INCS += firmware/inc
INCS += hardware/inc
INCS += system/inc
INCS += user/inc
INCS := $(addprefix -I, $(INCS))

OBJS += cmsis/startup/startup_stm32f10x_md.o 
OBJS += cmsis/system_stm32f10x.o 	# code startup from flash 
OBJS += firmware/src/stm32f10x_rcc.o
OBJS += firmware/src/stm32f10x_gpio.o 
OBJS += hardware/src/led.o
OBJS += user/main.o

CFLAGS += -mcpu=cortex-m3 -mthumb
CFLAGS += -Wall
#CFLAGS += -std=gnu99
#CFLAGS += -Wno-unused-variable 	# don't waring unused variable 
#CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16 #use hard float uint
#CFLAGS += -nostartfiles
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -Os	# optimize for size
#CFLAGS += -g	# -DDEBUG

ARFLAGS = cr

LDFLAGS += -mcpu=cortex-m3 -mthumb 
#LDFLAGS += -specs=nano.specs 
#LDFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
LDFLAGS += -Wl,--gc-sections 
LDFLAGS += -Wl,-Map=$(TARGET).map

LDSCRIPT = cmsis/stm32_flash.ld


all: $(TARGET).bin $(TARGET).hex

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary -S $< $@

$(TARGET).hex: $(TARGET).elf
	$(OBJCOPY) -O ihex -S $< $@

$(TARGET).elf: $(OBJS)
	$(CC) $(LDFLAGS) $^ -T$(LDSCRIPT) -o $@
	$(OBJDUMP) -D -m arm $@ > $(TARGET).dis
	$(SIZE) $@


burn: $(TARGET).bin
	st-flash write $< 0x08000000


%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) $(DEFS) $(INCS) -c $< -o $@
	

distclean: clean
	rm -rf $(TARGET).*

clean:
	rm -f $(OBJS)

.PHONY: all burn clean distclean

