##########################################################################################################################
# STM32F103 Makefile - 简化版本
# 针对当前项目结构优化
##########################################################################################################################

# ------------------------------------------------
# 1. 项目基础配置
# ------------------------------------------------
TARGET = stm32f103_project
DEBUG = 1
OPT = -Os

# 指定链接脚本
LDSCRIPT = stm32f103c8t6_blink.ld

# ------------------------------------------------
# 2. 目录结构定义
# ------------------------------------------------
BUILD_DIR = build

# ------------------------------------------------
# 3. 源文件列表
# ------------------------------------------------
# 用户源码
USER_C_SOURCES = \
Src/main.c

# CMSIS 系统文件
CMSIS_C_SOURCES = \
Drivers/CMSIS/Device/ST/STM32F1xx/Source/Templates/system_stm32f1xx.c

# 汇编启动文件
ASM_SOURCES = \
Drivers/CMSIS/Device/ST/STM32F1xx/Source/Templates/gcc/startup_stm32f103xb.s

# 合并所有源文件
C_SOURCES = $(USER_C_SOURCES) $(CMSIS_C_SOURCES)

# ------------------------------------------------
# 4. 头文件路径
# ------------------------------------------------
C_INCLUDES = \
-ISrc \
-IDrivers/CMSIS/Core/Include \
-IDrivers/CMSIS/Device/ST/STM32F1xx/Include

# ------------------------------------------------
# 5. 编译器与链接器参数
# ------------------------------------------------
PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

CPU = -mcpu=cortex-m3
MCU = $(CPU) -mthumb -mfloat-abi=soft

# 宏定义
C_DEFS = -DSTM32F103xB

# 编译参数
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# 汇编参数
ASFLAGS = $(MCU) -c -x assembler-with-cpp

# 链接参数
LIBS = -lnosys
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--gc-sections

# ------------------------------------------------
# 6. 对象文件列表
# ------------------------------------------------
OBJECTS = $(addprefix $(BUILD_DIR)/,$(C_SOURCES:.c=.o))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(ASM_SOURCES:.s=.o))

# ------------------------------------------------
# 7. 构建规则
# ------------------------------------------------
# 默认目标
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

# 编译 C 文件
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@echo "CC $<"
	@$(CC) -c $(CFLAGS) $< -o $@

# 编译汇编文件
$(BUILD_DIR)/%.o: %.s
	@mkdir -p $(dir $@)
	@echo "AS $<"
	@$(AS) -c $(ASFLAGS) $< -o $@

# 链接
$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS)
	@echo "LINK $@"
	@$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	@$(SZ) $@

# 生成 Hex/Bin
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf
	@$(HEX) $< $@

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf
	@$(BIN) $< $@

# 清理
clean:
	-rm -fR $(BUILD_DIR)

#######################################
# OpenOCD Flash Target
#######################################
# 烧录命令详解：
# -f interface/stlink.cfg : 指定调试器为 ST-Link
# -f target/stm32f1x.cfg  : 指定目标芯片为 STM32F1 系列
# -c "program ..."        : 执行烧录
#     verify              : 烧录后校验
#     reset               : 烧录后复位运行
#     exit                : 完成后退出 OpenOCD
flash: all
	openocd -f interface/stlink.cfg -f target/stm32f1x.cfg -c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"

# 烧录 (OpenOCD)
flash: all
	openocd -f interface/stlink.cfg -f target/stm32f1x.cfg \
	-c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"

.PHONY: all clean flash

# 引入依赖文件
-include $(wildcard $(BUILD_DIR)/*.d)