#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//使脚本可以提供用户输入界面
#property script_show_inputs

input datetime time = D'2010.01.09 00:00';
input string  用户输入信息 = "";


void OnStart()
{  
   printf("用户输入的信息：" + string(time));
   printf("用户输入的信息：" + 用户输入信息);
}