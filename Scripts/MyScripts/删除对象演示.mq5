#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//使脚本可以提供用户输入界面
#property script_show_inputs

input string Object_Name = "请输入要删除的对象名称";

void OnStart()
{  
   ObjectDelete(0, Object_Name);
}