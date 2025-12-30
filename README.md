# STM32F103 CMSIS Example Project

A CMSIS-based example project for STM32F103C8T6 microcontroller, demonstrating embedded development using ARM CMSIS libraries.

## Project Overview

This project is a simple LED blink example using STM32F103C8T6 (Cortex-M3 core) microcontroller with direct register manipulation for GPIO control.

### Key Features

- Based on ARM CMSIS standard library
- STM32F103C8T6 microcontroller support
- Simple LED blinking functionality
- Complete Makefile build system
- OpenOCD flashing support

## Hardware Requirements

- STM32F103C8T6 development board (Blue Pill)
- ST-Link V2 debugger
- LED connected to PC13 pin

## Project Structure

```
my_cmsis_example/
├── Drivers/              # CMSIS driver files
│   └── CMSIS/
│       ├── Core/         # Cortex-M core support
│       └── Device/       # STM32F1 series device support
├── Inc/                  # Header files directory
│   └── main.h
├── Src/                  # Source files directory
│   ├── main.c           # Main program file
│   └── stm32f1xx_it.c   # Interrupt service routines
├── Makefile             # Build configuration
├── stm32f103c8t6_blink.ld # Linker script
└── STM32F103.svd        # Debug description file
```

## Quick Start

### Prerequisites

- ARM GCC toolchain (arm-none-eabi-gcc)
- OpenOCD (for flashing)
- ST-Link V2 debugger

### Building the Project

```bash
# Clone the project
git clone <repository-url>
cd my_cmsis_example

# Build the project
make
```

### Flashing to Device

```bash
# Connect ST-Link V2 to the board
make flash
```

### Cleaning Build Files

```bash
make clean
```

## Code Explanation

### Main Program (main.c)

The main program implements the following functionality:

1. System clock configured to 72MHz (external crystal 8MHz)
2. Enable GPIOC clock
3. Configure PC13 pin as push-pull output
4. Toggle PC13 pin state in main loop for LED blinking

```c
#include "stm32f1xx.h"

int main(void) {
    // Enable PC13 clock
    RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;

    // Configure PC13 output mode
    GPIOC->CRH &= ~(GPIO_CRH_MODE13 | GPIO_CRH_CNF13); 
    GPIOC->CRH |= GPIO_CRH_MODE13_1; // Output 2MHz

    while (1) {
        GPIOC->ODR ^= GPIO_ODR_ODR13; // XOR operation for toggling
        
        // Simple delay
        for (volatile int i = 0; i < 500000; i++);
    }
}
```

## Hardware Connections

| Board Pin | Function | Connection Description |
|-----------|----------|------------------------|
| PC13      | LED      | Connect to LED (anode through resistor) |
| 3.3V      | Power    | Board power supply |
| GND       | Ground   | Board ground |

## Development Tools

### Compiler
- ARM GCC toolchain (arm-none-eabi-gcc)

### Debugger
- OpenOCD
- ST-Link V2

### Recommended IDEs
- VS Code with Cortex-Debug extension
- STM32CubeIDE
- Keil MDK

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Issues and Pull Requests are welcome to improve this project.

## Related Resources

- [ARM CMSIS Documentation](https://arm-software.github.io/CMSIS_5/General/html/index.html)
- [STM32F103 Reference Manual](https://www.st.com/resource/en/reference_manual/rm0008-stm32f101xx-stm32f102xx-stm32f103xx-stm32f105xx-and-stm32f107xx-advanced-armbased-32bit-mcus-stmicroelectronics.pdf)
- [STM32F103 Datasheet](https://www.st.com/resource/en/datasheet/stm32f103c8.pdf)

## Troubleshooting

### Common Issues

1. **Compilation Error: arm-none-eabi-gcc not found**
   - Ensure ARM GCC toolchain is installed
   - Check PATH environment variable

2. **Flashing Failed: Cannot connect to ST-Link**
   - Verify ST-Link connection
   - Confirm device power supply
   - Check OpenOCD configuration

3. **LED Not Blinking**
   - Verify hardware connections
   - Confirm PC13 pin connection
   - Check resistor value and LED polarity

## Version History

- v1.0.0 - Initial version, basic LED blinking functionality