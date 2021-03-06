//+------------------------------------------------------------------+
//|                                     ArraySetAsSeries函数测试.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <MyClass\shuju.mqh>
ShuJu shuju;

double kma[];
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   shuju.MA(kma, 3, Symbol(), 0, 10, 0, MODE_EMA, PRICE_CLOSE);
   //printf("数组是否为时序数组： " + ArrayIsSeries(kma));
   
   printf("MA: " + NormalizeDouble(kma[2], 6));
}

