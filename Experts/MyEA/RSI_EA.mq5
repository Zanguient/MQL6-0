//+------------------------------------------------------------------+
//|                                                       RSI_EA模板 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "RSI_EA模板"
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| 引入程序需要的类库并创建对象                                     |
//+------------------------------------------------------------------+
#include <MyClass\shuju.mqh>
#include <MyClass\交易类\信息类.mqh>
#include <MyClass\交易类\交易指令.mqh>

ShuJu shuju;
账户信息 zh;
仓位信息 cw;
交易指令 jy;

//+------------------------------------------------------------------+
//| 初始化全局变量                                                   |
//+------------------------------------------------------------------+
input ENUM_TIMEFRAMES TIMEFRAMES = PERIOD_M5; // 图标周期
input int RSI_MA = 14;
input int TP_PLUS = 3;  //止盈为止损的倍数

double Lots = 0.01;     // 下单量 
int SP = 0;             // 止损点位
int TP = 0;             // 止盈点位
int DEVIATION = 3;      // 允许最大滑点
int MAGIC = 333;        // 自定义EA编码

int N_ORDER_BUY = 0;    //已开仓多单数量
int N_ORDER_SELL= 0;    //已开仓空单数量

double HIGH_PRICE = 0;  // N日内最高价
double LOW_PRICE = 0;   // N日内最低价
double CLOSE_PRICE = 0; // N日内收盘价

double RSI_DATA[];      // RSI指标值
double HIGH[];
double LOW[];
double CLOSE[];
//+------------------------------------------------------------------+
//| 初始化函数，程序首次运行仅执行一次                               |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| 主函数，价格每波动一次执行一次                                   |
//+------------------------------------------------------------------+
void OnTick()
{
   //获取RSI指标数据
   shuju.RSI(RSI_DATA, 3, Symbol(), TIMEFRAMES, RSI_MA, PRICE_CLOSE);
   //获取十五日内的最高价、最低价、收盘价
   shuju.gethigh(HIGH, 15, Symbol(), TIMEFRAMES);
   shuju.getlow(LOW, 15, Symbol(), TIMEFRAMES);
   shuju.getclose(CLOSE, 15, Symbol(), TIMEFRAMES);
   //获取已开仓订单数量
   N_ORDER_BUY  = cw.OrderNumber(Symbol(), 0, MAGIC);
   N_ORDER_SELL = cw.OrderNumber(Symbol(), 1, MAGIC);
   
   //按指定条件开BUY单
   if(RSI_DATA[2] < 30 && RSI_DATA[1] > 30)
   {
      LOW_PRICE = LOW[ArrayMinimum(LOW, 1)];           //寻找最低价
      SP = int((shuju.getask(Symbol()) - LOW_PRICE) / Point() - 5);
      TP = SP * TP_PLUS;
      
      if(N_ORDER_BUY == 0)
      {
         jy.OrderOpen(Symbol(), ORDER_TYPE_BUY, Lots, SP, TP, "BUY_RSI_EA", MAGIC, DEVIATION);
      }
   }
   //按指定条件开SELL单
   if(RSI_DATA[2] > 70 && RSI_DATA[1] < 70)
   {
      HIGH_PRICE = HIGH[ArrayMaximum(HIGH, 1)];        //寻找最高价
      SP = int((HIGH_PRICE - shuju.getbid(Symbol())) / Point() + 5);
      TP = SP * TP_PLUS;
      
      if(N_ORDER_SELL == 0)
      {
         jy.OrderOpen(Symbol(), ORDER_TYPE_SELL, Lots, SP, TP, "SELL_RSI_EA", MAGIC, DEVIATION);
      }
   }
}

//+------------------------------------------------------------------+
//| 程序关闭时执行一次，释放占用内存                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   printf("智能交易程序已关闭！");
   printf("图表窗口被关闭或者智能程序被卸载！");
}

//=========================== 程序的最后一行==========================

