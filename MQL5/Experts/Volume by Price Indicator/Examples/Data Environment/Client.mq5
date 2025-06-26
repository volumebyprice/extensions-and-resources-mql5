//+------------------------------------------------------------------+
//|                                                       Client.mq5 |
//|                                              Volume by Price MT5 |
//|                                    https://www.volumebyprice.com |
//+------------------------------------------------------------------+

#include <Volume by Price Indicator\\Data Environment\\Client.mqh>

CEnvironmentObject Environment;

ulong prev_tickcount;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   //Environment.NameSet("default");    
   
   EventSetMillisecondTimer(100);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---  

   if (Environment.SegmentsTotal()<1) return;

   if (Environment.GetTickCount()==prev_tickcount) return; 
   prev_tickcount = Environment.GetTickCount();
   
   // --- get current segment by index
   
   SSegment segment;
   Environment.SegmentGet(segment,Environment.SegmentsTotal()-1);
 
   datetime ctime                      = segment.ctime;
   
   datetime time_start                 = segment.time_start;
   long     volume_total               = segment.volume_total;
   int      tpo_total                  = segment.tpo_total;

   Print(Environment.SegmentsTotal());
      
   Print(Environment.GetTickCount());

   Print(TimeToString(ctime,TIME_DATE|TIME_MINUTES|TIME_SECONDS));   
   Print(TimeToString(time_start,TIME_DATE|TIME_MINUTES));
   Print(volume_total);
   Print(tpo_total);
   
   if (ArraySize(segment.level)==0) return;
   
   // --- get price metric by index
   
   double   vp_poc_median_price        = segment.price[VariableNameIndex(VBP_ENV_VP_POC_MEDIAN)];
   double   mp_poc_median_price        = segment.price[VariableNameIndex(VBP_ENV_MP_POC_MEDIAN)];    
   
   Print(vp_poc_median_price);
   Print(mp_poc_median_price);   

   Print(ArraySize(segment.level));

   // --- get price metric level by index

   long     vp_poc_median_volume_total = segment.level[segment.index[VariableNameIndex(VBP_ENV_VP_POC_MEDIAN)]].volume_total;
   int      mp_poc_median_tpo_total    = segment.level[segment.index[VariableNameIndex(VBP_ENV_MP_POC_MEDIAN)]].tpo_total; 
   int      mp_poc_median_tpo_index[];
   
   ArrayCopy(mp_poc_median_tpo_index,segment.level[segment.index[VariableNameIndex(VBP_ENV_MP_POC_MEDIAN)]].tpo_index);
   
   bool     vp_poc_median_is_current_level   = segment.index[VariableNameIndex(VBP_ENV_VP_POC_MEDIAN)]==segment.index[VariableNameIndex(VBP_ENV_CPRICE)];
   bool     mp_poc_median_is_current_level   = segment.index[VariableNameIndex(VBP_ENV_MP_POC_MEDIAN)]==segment.index[VariableNameIndex(VBP_ENV_CPRICE)];
   
   Print(vp_poc_median_volume_total);
   Print(mp_poc_median_tpo_total);
   PrintArray(mp_poc_median_tpo_index);
   
   Print(vp_poc_median_is_current_level);
   Print(mp_poc_median_is_current_level);
   
   // --- iterate over price levels
   
   for (int index=0;index<ArraySize(segment.level);index++) {
   
      int      level_index             = index;
      double   level_price             = segment.level[index].price;
      long     level_volume_total      = segment.level[index].volume_total;
      long     level_volume_delta      = segment.level[index].volume_delta;
      int      level_tpo_total         = segment.level[index].tpo_total;
      int      level_tpo_index[];
      
      ArrayCopy(level_tpo_index,segment.level[index].tpo_index);
      
      // --- get price metric level by flag
      
      int      level_flags             = segment.level[index].flags;

      bool     level_is_vp_poc_median  = VariableFlag(segment.level[index].flags,VBP_ENV_VP_POC_MEDIAN);
      bool     level_is_mp_poc_median  = VariableFlag(segment.level[index].flags,VBP_ENV_MP_POC_MEDIAN);      

      // --- get current price level

      if (VariableFlag(segment.level[index].flags,VBP_ENV_CPRICE)) {

         Print(level_index);    
         Print(level_price);    
         Print(level_volume_total);
         Print(level_volume_delta);
         Print(level_tpo_total);    
         PrintArray(level_tpo_index);
         PrintBits(level_flags);
         Print(level_is_vp_poc_median);
         Print(level_is_mp_poc_median);
      
      }
   
   } 
   
  }
//+------------------------------------------------------------------+

template<typename T>
void PrintArray(T &array[], string delimiter = " ") { 

   string str = "";
   for (int i=0;i<ArraySize(array);i++) str += (string)array[i]+delimiter;
   Print(str);

}

template<typename T>
void PrintBits(T &data) { 

   string str = "";   
   for (int i=0;i<sizeof(data)*8;i++) str = (string)(char)bool(T(data&(B'1'<<i))==T(B'1'<<i))+str;   
   Print(str);

}


