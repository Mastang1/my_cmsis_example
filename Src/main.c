#include "stm32f1xx.h"

int main(void) {
    // 1. 系统时钟已经在启动时由 SystemInit 配置为 72MHz (外部晶振 8MHz)
    
    // 2. 使能 PC13 时钟
    RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;

    // 3. 配置 PC13 输出模式
    GPIOC->CRH &= ~(GPIO_CRH_MODE13 | GPIO_CRH_CNF13); 
    GPIOC->CRH |= GPIO_CRH_MODE13_1; // Output 2MHz

    while (1) {
        GPIOC->ODR ^= GPIO_ODR_ODR13; // 异或操作实现翻转
        
        // 简单延时
        for (volatile int i = 0; i < 500000; i++);
    }
}