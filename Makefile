####################
# main configuration
####################
TARGET    := monarch_v9
PROGRAM   := $(TARGET)
BUILD_DIR := build
SRC_DIR   := source
INC_DIR   := include
DATA_DIR  := data

# Si tu as encore un dossier src/ et data/, il les prend aussi
SOURCES   := $(SRC_DIR) $(DATA_DIR) src data

TITLE     := MONARCHV9
GAME_CODE := MNV9
MAKER_CODE:= 01
REVISION  := 0
UART_DEV  := /dev/ttyUSB0

####################
# toolchain
####################
PREF    := arm-none-eabi-
CC      := $(PREF)gcc
CXX     := $(PREF)g++
AS      := $(PREF)as
LD      := $(PREF)g++
OBJCOPY := $(PREF)objcopy

####################
# libgba / devkitPro detection
####################
ifeq ($(strip $(DEVKITPRO)),)
  # mode bare libgba/ que tu avais
  LIBGBA      := libgba
  LIBGBA_INC  := $(LIBGBA)/include
  LIBGBA_LIB  := $(LIBGBA)/lib
  LIBGBA_CRT  := $(LIBGBA)/gba_crt0.o
  LIBGBA_LD   := $(LIBGBA)/gba_cart.ld
  LIBGBA_FLAGS:= -I $(LIBGBA_INC)
  LIBGBA_LDFLAGS := -L $(LIBGBA_LIB) -lgba -nostartfiles $(LIBGBA_CRT) -Wl,-T,$(LIBGBA_LD)
  GBA_RULES :=
else
  # mode devkitPro
  LIBGBA_FLAGS:= -I $(DEVKITPRO)/libgba/include -I $(INC_DIR)
  LIBGBA_LDFLAGS := -L $(DEVKITPRO)/libgba/lib -lgba
  GBA_RULES := $(DEVKITPRO)/libgba/gba_rules
endif

####################
# flags - fusion V7 + ton LTO
####################
ARCH    := -mthumb -mthumb-interwork
CPU     := -mcpu=arm7tdmi -mtune=arm7tdmi

CFLAGS   := -g -O2 -Wall -Wextra -flto -fomit-frame-pointer -ffast-math $(ARCH) $(CPU) -I $(INC_DIR) $(LIBGBA_FLAGS) -DMAX_CITY_PER_PLANET=300 -DPLANET_COUNT=12
CXXFLAGS := -g -O2 -Wall -Wextra -flto -fomit-frame-pointer -ffast-math -fno-exceptions -fno-rtti -fpermissive $(ARCH) $(CPU) -I $(INC_DIR) $(LIBGBA_FLAGS) -DMAX_CITY_PER_PLANET=300 -DPLANET_COUNT=12
ASFLAGS  := -g $(ARCH) $(CPU) -I $(INC_DIR)

# Map + nano + nosys que tu avais + gba.specs si dispo
LDFLAGS  := -Wl,-Map=$(BUILD_DIR)/$(TARGET).map $(ARCH) $(CPU) -flto --specs=nano.specs --specs=nosys.specs -Wl,--gc-sections

ifdef DEVKITPRO
  LDFLAGS += -specs=gba.specs
endif

####################
# sources
####################
C_BUILD_DIR   := $(BUILD_DIR)/c
CXX_BUILD_DIR := $(BUILD_DIR)/cxx
ASM_BUILD_DIR := $(BUILD_DIR)/asm
DATA_BUILD_DIR:= $(BUILD_DIR)/data

C_SRCS   := $(shell find $(SOURCES) -type f -name '*.c' 2>/dev/null)
CXX_SRCS := $(shell find $(SOURCES) -type f -name '*.cpp' 2>/dev/null)
ASM_SRCS := $(shell find $(SOURCES) -type f -name '*.s' 2>/dev/null)
S_SRCS   := $(shell find $(SOURCES) -type f -name '*.S' 2>/dev/null)

C_OBJS   := $(patsubst %.c,$(C_BUILD_DIR)/%.o,$(C_SRCS))
CXX_OBJS := $(patsubst %.cpp,$(CXX_BUILD_DIR)/%.o,$(CXX_SRCS))
ASM_OBJS := $(patsubst %.s,$(ASM_BUILD_DIR)/%.o,$(ASM_SRCS))
S_OBJS   := $(patsubst %.S,$(ASM_BUILD_DIR)/%.o,$(S_SRCS))

OFILES := $(C_OBJS) $(CXX_OBJS) $(ASM_OBJS) $(S_OBJS)
OBJS   := $(OFILES)

####################
# rules
####################
.PHONY: all clean flash rebuild

all: $(TARGET).gba

# devkitPro a ses propres règles, on les inclut si dispo
ifneq ($(GBA_RULES),)
  include $(GBA_RULES)
endif

$(TARGET).gba: $(TARGET).elf
	@echo "[OBJCOPY] $@"
	@$(OBJCOPY) -O binary $< $@
	@gbafix $@ -t"$(TITLE)" -c$(GAME_CODE) -m$(MAKER_CODE) -r$(REVISION) -p --silent || gbafix $@ -t"$(TITLE)" -c$(GAME_CODE) -m$(MAKER_CODE) -r$(REVISION)

$(TARGET).elf: $(BUILD_DIR)/$(TARGET).elf
	@cp $< $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	@echo "[LD] $@"
	@mkdir -p $(dir $@)
	@$(LD) -o $@ $^ $(CXXFLAGS) $(LIBGBA_LDFLAGS) $(LDFLAGS)

$(C_BUILD_DIR)/%.o: %.c
	@echo "[CC] $<"
	@mkdir -p $(dir $@)
	@$(CC) -c -o $@ $< $(CFLAGS) -MMD -MP

$(CXX_BUILD_DIR)/%.o: %.cpp
	@echo "[CXX] $<"
	@mkdir -p $(dir $@)
	@$(CXX) -c -o $@ $< $(CXXFLAGS) -MMD -MP

$(ASM_BUILD_DIR)/%.o: %.s
	@echo "[AS] $<"
	@mkdir -p $(dir $@)
	@$(AS) -o $@ $< $(ASFLAGS)

$(ASM_BUILD_DIR)/%.o: %.S
	@echo "[AS] $<"
	@mkdir -p $(dir $@)
	@$(CC) -c -o $@ $< $(ASFLAGS)

# convertit .bin png etc en .o automatiquement si tu as data/
$(DATA_BUILD_DIR)/%.o: %
	@mkdir -p $(dir $@)
	@arm-none-eabi-ld -r -b binary -o $@ $<

clean:
	rm -rf $(BUILD_DIR) $(TARGET).gba $(TARGET).elf *.map
	@if [ -d libgba ]; then make -C libgba clean; fi

rebuild: clean all

flash:
	@echo "Flash sur $(UART_DEV)"
	# ajoute ta commande de flash ici

# dépendances auto
-include $(OBJS:.o=.d)