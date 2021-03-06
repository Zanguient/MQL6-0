#property copyright "存储历史数据，用于LSTM网络训练"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs //使脚本可以提供用户输入界面

//+------------------------------------------------------------------+
//| 初始化全局变量                                                   |
//+------------------------------------------------------------------+
input string 交易品种名称 = "EURUSD";
input ENUM_TIMEFRAMES 图表周期 = PERIOD_M1;
input datetime inputTime = D'2004.01.01 00:00';
input int 预测时间 = 15;  //预测多少分钟内的涨跌趋势（以分钟计算）
input int 目标点位 = 50;  //预测时间内的涨跌幅度（以点位计算）

string FileName = ".txt";
int totle_k = iBarShift(交易品种名称, 图表周期, inputTime);

double highPrice[];
double openPrice[];
double lowPrice[];
double closePrice[];

long tickVolume[];


//+------------------------------------------------------------------+
//| 脚本程序启动函数,仅执行一次                                      |
//+------------------------------------------------------------------+
void OnStart()
{
   //调用SaveData函数,把数据写入文件
   SaveData();
}

//+------------------------------------------------------------------+
//| 保存数据函数，把数据写入文件                                     |
//+------------------------------------------------------------------+
void SaveData()
{
   //获取蜡烛图的高开低收价格
   CopyHigh (交易品种名称, 图表周期, 0, totle_k, highPrice);
   CopyOpen (交易品种名称, 图表周期, 0, totle_k, openPrice);
   CopyLow  (交易品种名称, 图表周期, 0, totle_k, lowPrice);
   CopyClose(交易品种名称, 图表周期, 0, totle_k, closePrice);
   CopyTickVolume(交易品种名称,图表周期, 0, totle_k, tickVolume);
   
   //以读写方式打开文件(如果没有此文件将创建此文件)
   int SaveData = FileOpen(FileName, FILE_READ|FILE_WRITE|FILE_SHARE_READ|FILE_TXT|FILE_ANSI, ",", CP_UTF8);
   //判断文件是否正确打开
   if(SaveData != INVALID_HANDLE)
   {
      //初始化变量
      string 验证信息 = "";
      int i, j, y = 0;
      int n = 0;
      for(i=0; i<totle_k-1; i++)
      {       
         for(j=i+1; j<预测时间+i+1; j++)
         {
            //防止数组越界
            if(j >= totle_k-1) n = totle_k-1;
            else n =j; 
  
            //遍历数据计算 y值      
            if(highPrice[n] - openPrice[i] >= 目标点位 * Point())
            {
               y = 1;               
               break;
            }
            if(openPrice[i] - lowPrice[n] >= 目标点位 * Point())
            {
               y = -1;
               break;
            }
            else y = 0;
         }
         //记录验证信息
         if(y < 0)  验证信息 = "从第" + string(i) + "根的开盘价至" + "第" + string(n) + "根的最低价 相差" + string(NormalizeDouble((openPrice[i] - lowPrice[n] )/Point(), 5)) + "点，大于" + string(目标点位) + "点目标点位";
         if(y > 0)  验证信息 = "从第" + string(i) + "根的开盘价至" + "第" + string(n) + "根的最高价 相差" + string(NormalizeDouble((highPrice[n] - openPrice[i])/Point(), 5)) + "点，大于" + string(目标点位) + "点目标点位";
         if(y == 0) 验证信息 = "未达到目标点位" + string(目标点位) + "点";
         
         //把数据写入文件
         FileWrite(SaveData, i, openPrice[i], highPrice[i], lowPrice[i], closePrice[i], tickVolume[i], y, 验证信息); 
      } 
      //关闭文件
      FileClose(SaveData);
      //提示保存成功
      printf( "已写入" + string(i) + "条记录！");     
   }
   else
   {
      printf("文件未找到或打开失败！");
   }
}
//+------------------------------------------------------------------+
