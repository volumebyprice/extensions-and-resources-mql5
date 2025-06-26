//+------------------------------------------------------------------+
//|                                                       Client.mqh |
//|                                              Volume by Price MT5 |
//|                                    https://www.volumebyprice.com |
//+------------------------------------------------------------------+

enum ENUM_VBP_ENV {
   
   VBP_ENV_TIME_START = 0,
   VBP_ENV_TIME_END = 1,
   VBP_ENV_RSIZE = 2,
   VBP_ENV_CTIME = 3,
   VBP_ENV_CPRICE = 4,
   VBP_ENV_CVOLUME_TOTAL = 5,
   VBP_ENV_CVOLUME_DELTA = 6,
   VBP_ENV_CVOLUME_DELTA_N = 7,
   VBP_ENV_CVOLUME_BUY = 8,
   VBP_ENV_CVOLUME_SELL = 9,    
   VBP_ENV_BVOLUME_TOTAL = 10,
   VBP_ENV_BVOLUME_DELTA = 11,
   VBP_ENV_BVOLUME_DELTA_N = 12,
   VBP_ENV_BVOLUME_DELTA_AVG = 13,
   VBP_ENV_BVOLUME_BUY = 14,
   VBP_ENV_BVOLUME_SELL = 15,    
   VBP_ENV_VOLUME_TOTAL = 16,
   VBP_ENV_VOLUME_DELTA = 17,
   VBP_ENV_VOLUME_DELTA_N = 18,
   VBP_ENV_VOLUME_DELTA_PCT = 19,      
   VBP_ENV_VOLUME_BUY = 20,
   VBP_ENV_VOLUME_SELL = 21, 
   VBP_ENV_VOLUME_COUNT = 22,
   VBP_ENV_VOLUME_COUNT_N = 23,
   VBP_ENV_VOLUME_COUNT_PCT = 24,
   VBP_ENV_VOLUME_COUNT_BUY = 25,
   VBP_ENV_VOLUME_COUNT_SELL = 26,   
   VBP_ENV_PRICE_SET = 27,
   VBP_ENV_VP_LOW = 28,
   VBP_ENV_VP_HIGH = 29,
   VBP_ENV_VP_RANGE = 30,
   VBP_ENV_VP_MEDIAN = 31,
   VBP_ENV_VP_BALANCE = 32,
   VBP_ENV_VP_POC_MEDIAN = 33,
   VBP_ENV_VP_POC_LOW = 34,
   VBP_ENV_VP_POC_HIGH = 35,
   VBP_ENV_VP_VA_LOW = 36,
   VBP_ENV_VP_VA_HIGH = 37,
   VBP_ENV_VP_VA_RANGE = 38,
   VBP_ENV_MP_LOW = 39,
   VBP_ENV_MP_HIGH = 40,
   VBP_ENV_MP_RANGE = 41,
   VBP_ENV_MP_MEDIAN = 42,
   VBP_ENV_MP_BALANCE = 43,
   VBP_ENV_MP_BODY_LOW = 44,
   VBP_ENV_MP_BODY_HIGH = 45,
   VBP_ENV_MP_POC_MEDIAN = 46,
   VBP_ENV_MP_POC_LOW = 47,
   VBP_ENV_MP_POC_HIGH = 48,
   VBP_ENV_MP_VA_LOW = 49,
   VBP_ENV_MP_VA_HIGH = 50,
   VBP_ENV_MP_VA_RANGE = 51,
   VBP_ENV_TPO_SET = 52,
   VBP_ENV_TPO_TIME = 53,   
   VBP_ENV_TPO_TOTAL = 54,
   VBP_ENV_TPO_COUNT = 55,
   VBP_ENV_TPO_COUNT_N = 56,
   VBP_ENV_TPO_COUNT_PCT = 57,
   VBP_ENV_TPO_COUNT_BUY = 58,
   VBP_ENV_TPO_COUNT_SELL = 59,
   VBP_ENV_IB_LOW = 60,
   VBP_ENV_IB_HIGH = 61,
   VBP_ENV_IB_RANGE = 62,
   VBP_ENV_VWAP = 63,

};

struct SLevel {

   double price;   
   
   long volume_total;   
   long volume_delta; 
   long volume_buy;
   long volume_sell;
   
   int tpo_total; 
   int tpo_index[];
   
   int flags;

};

struct SSegment {

   datetime time_start;
   datetime time_end;
   
   int rsize;
   
   long ctime;
   double cprice;   
   long cvolume_total;
   long cvolume_delta;
   long cvolume_delta_n;
   long cvolume_buy;
   long cvolume_sell;  
   
   long bvolume_total;
   long bvolume_delta;
   long bvolume_delta_n;
   long bvolume_delta_avg;
   long bvolume_buy;
   long bvolume_sell;
   
   long volume_total;
   long volume_delta;
   long volume_delta_n;
   double volume_delta_pct;    
   long volume_buy;
   long volume_sell; 
   long volume_count;
   long volume_count_n;
   double volume_count_pct;
   long volume_count_buy;
   long volume_count_sell;  
   
   double price_set;

   int tpo_set;
   int tpo_time;  
   int tpo_total;
   int tpo_count;
   int tpo_count_n;
   double tpo_count_pct;
   int tpo_count_buy;
   int tpo_count_sell;

   double price[24];
   
   int index[24];
   
   SLevel level[];

};

int VariableNameIndex(const ENUM_VBP_ENV name) {
   
   static const int index[] = {4,28,29,31,32,33,34,35,36,37,39,40,42,43,44,45,46,47,48,49,50,60,61,63};
   
   for (int i=0;i<ArraySize(index);i++) if ((int)name==index[i]) return i;
   
   return -1;

}

bool VariableFlag(const int flags, const ENUM_VBP_ENV name) {

   const int index = VariableNameIndex(name);

   if (index<0) return false;

   const int flag = (B'1'<<index);

   return (flags&flag) == flag;

}

class CEnvironment {

   protected:      
      
      string prefix;
   
   public:
      
      CEnvironment() : prefix("VBP") {} ~CEnvironment() {}

      void NameSet(string name) {
      
         StringToUpper(name);
        
         if (name=="DEFAULT") prefix = "VBP"; else if (StringFind(name,"VBP")==0) prefix = name; else prefix = StringFormat("VBP_%s",name);
         
      } 
      
      ulong GetTickCount() {
      
         return GlobalVariableCheck(StringFormat("%s_TC",prefix)) ? (long)GlobalVariableGet(StringFormat("%s_TC",prefix)) : 0;
      
      }       

};

class CEnvironmentGlobalVariables : public CEnvironment {

   public:
      
      CEnvironmentGlobalVariables(void) {} ~CEnvironmentGlobalVariables(void) {}

      int SegmentsTotal() {
      
         int s = 0;
      
         for (int i=0;GlobalVariableCheck(VariableNameFormat(VBP_ENV_TIME_START,i));i++) s = i+1;
         
         return s;
      
      }
      
      template<typename T> string VariableNameFormat(const T t, int s = -1) {
  
         if (s==-1) s = SegmentsTotal()-1;
  
         static string n;
  
         n = (string)t;
         
         if (typename(t)==StringFormat("enum ENUM_%s","VBP_ENV")) n = EnumToString((ENUM_VBP_ENV)t);
      
         StringReplace(n,StringFormat("%s_","VBP_ENV"),"");
      
         return StringFormat("%s%s_%s",prefix,s>0?StringFormat("[%i]",s):"",n);
         
      }

};

class CEnvironmentFiles : public CEnvironment {
  
   public:
      
      CEnvironmentFiles(void) {} ~CEnvironmentFiles(void) {}

      int SegmentsTotal() {
      
         int s = 0;
      
         for (int i=0;FileIsExist(FileNameFormat(i));i++) s = i+1;
         
         return s;
      
      }
      
      string FileNameFormat(int s = -1) {
  
         if (s==-1) s = SegmentsTotal()-1;
      
         return "Volume by Price Indicator\\Data Environment"+"\\"+StringFormat("%s_%i.DAT",prefix,s);
         
      }    
            
      uint FileRead(const int &file_handle, SLevel &struct_object_array[]) {
      
         ArrayResize(struct_object_array,0);
      
         static uint r;
      
         r = 0;
      
         if (file_handle==INVALID_HANDLE) return r;
         
         FileReadLong(file_handle);
         
         static int s, ss;
         
         s = FileReadInteger(file_handle,INT_VALUE);
         
         ArrayResize(struct_object_array,s);
         
         static int i, ii;
         
         for (i=0;i<s && !IsStopped();i++) {
         
            struct_object_array[i].price = FileReadDouble(file_handle); r += sizeof(double);
            
            struct_object_array[i].volume_total = FileReadLong(file_handle); r += sizeof(long);
            
            struct_object_array[i].volume_delta = FileReadLong(file_handle); r += sizeof(long);
            
            if (struct_object_array[i].volume_delta==0) {
            
               struct_object_array[i].volume_buy = struct_object_array[i].volume_total/2; r += sizeof(long);
               
               struct_object_array[i].volume_sell = struct_object_array[i].volume_total/2; r += sizeof(long);
            
            } else              
            
            if (struct_object_array[i].volume_delta>0) {
            
               struct_object_array[i].volume_buy = (struct_object_array[i].volume_total/2)+struct_object_array[i].volume_delta; r += sizeof(long);
               
               struct_object_array[i].volume_sell = struct_object_array[i].volume_total-struct_object_array[i].volume_buy; r += sizeof(long);
            
            } else

            if (struct_object_array[i].volume_delta<0) {
            
               struct_object_array[i].volume_sell = (struct_object_array[i].volume_total/2)+(-struct_object_array[i].volume_delta); r += sizeof(long);
               
               struct_object_array[i].volume_buy = struct_object_array[i].volume_total-struct_object_array[i].volume_sell; r += sizeof(long);
            
            }            
            
            struct_object_array[i].tpo_total = FileReadInteger(file_handle,INT_VALUE); r += sizeof(int);
            
            ss = FileReadInteger(file_handle,INT_VALUE);
               
            ArrayResize(struct_object_array[i].tpo_index,ss); r += sizeof(int)*ss;
            
            for (ii=0;ii<ss;ii++) struct_object_array[i].tpo_index[ii] = FileReadInteger(file_handle,INT_VALUE);
             
         } 
         
         return r;
      
      }        

};

class CEnvironmentObject : public CEnvironment {
  
   private:
   
      CEnvironmentGlobalVariables EnvironmentGlobalVariables;
      CEnvironmentFiles EnvironmentFiles;
  
   public:
      
      CEnvironmentObject(void) { EnvironmentGlobalVariables.NameSet(prefix); EnvironmentFiles.NameSet(prefix); } ~CEnvironmentObject(void) {}
      
      int SegmentsTotal() {
      
         return EnvironmentGlobalVariables.SegmentsTotal();
      
      }      
      
      void SegmentGet(SSegment &struct_object, int s = -1) {
      
         if (s==-1) s = SegmentsTotal()-1;
      
         ZeroMemory(struct_object);  
      
         struct_object.time_start = (datetime)(long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TIME_START,s));
         struct_object.time_end = (datetime)(long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TIME_END,s));
         
         struct_object.rsize = (int)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_RSIZE,s));
         
         struct_object.ctime = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_CTIME,s));
         struct_object.cprice = (double)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_CPRICE,s));   
         struct_object.cvolume_total = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_CVOLUME_TOTAL,s));
         struct_object.cvolume_delta = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_CVOLUME_DELTA,s));
         struct_object.cvolume_delta_n = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_CVOLUME_DELTA_N,s));
         struct_object.cvolume_buy = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_CVOLUME_BUY,s));
         struct_object.cvolume_sell = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_CVOLUME_SELL,s));  
         
         struct_object.bvolume_total = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_BVOLUME_TOTAL,s));
         struct_object.bvolume_delta = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_BVOLUME_DELTA,s));
         struct_object.bvolume_delta_n = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_BVOLUME_DELTA_N,s));
         struct_object.bvolume_delta_avg = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_BVOLUME_DELTA_AVG,s));
         struct_object.bvolume_buy = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_BVOLUME_BUY,s));
         struct_object.bvolume_sell = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_BVOLUME_SELL,s));
         
         struct_object.volume_total = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_TOTAL,s));
         struct_object.volume_delta = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_DELTA,s));
         struct_object.volume_delta_n = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_DELTA_N,s));
         struct_object.volume_delta_pct = (double)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_DELTA_PCT,s));    
         struct_object.volume_buy = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_BUY,s));
         struct_object.volume_sell = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_SELL,s)); 
         struct_object.volume_count = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_COUNT,s));
         struct_object.volume_count_n = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_COUNT_N,s));
         struct_object.volume_count_pct = (double)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_COUNT_PCT,s));
         struct_object.volume_count_buy = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_COUNT_BUY,s));
         struct_object.volume_count_sell = (long)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_VOLUME_COUNT_SELL,s));  
         
         struct_object.price_set = (double)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_PRICE_SET,s));
      
         struct_object.tpo_set = (int)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TPO_SET,s));
         struct_object.tpo_time = (int)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TPO_TIME,s));  
         struct_object.tpo_total = (int)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TPO_TOTAL,s));
         struct_object.tpo_count = (int)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TPO_COUNT,s));
         struct_object.tpo_count_n = (int)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TPO_COUNT_N,s));
         struct_object.tpo_count_pct = (double)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TPO_COUNT_PCT,s));
         struct_object.tpo_count_buy = (int)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TPO_COUNT_BUY,s));
         struct_object.tpo_count_sell = (int)GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat(VBP_ENV_TPO_COUNT_SELL,s));           
         
         static int file_handle;
         file_handle = FileOpen(EnvironmentFiles.FileNameFormat(s),FILE_READ|FILE_SHARE_READ|FILE_BIN); 
         EnvironmentFiles.FileRead(file_handle,struct_object.level);
         FileClose(file_handle);      
         
         LevelIndex(struct_object,s);
      
      }         
   
   private:
      
      void LevelIndex(SSegment &struct_object, const int &s) {
      
         static const int index[] = {4,28,29,31,32,33,34,35,36,37,39,40,42,43,44,45,46,47,48,49,50,60,61,63};
         
         static double p;
         
         static int i, ii;
         
         ArrayInitialize(struct_object.index,-1);
         
         for (ii=0;ii<ArraySize(struct_object.level) && !IsStopped();ii++) {
         
            struct_object.level[ii].flags = NULL;
         
            for (i=0;i<ArraySize(index) && !IsStopped();i++) {
            
               if (!GlobalVariableCheck(EnvironmentGlobalVariables.VariableNameFormat((ENUM_VBP_ENV)index[i],s))) continue;
               
               p = GlobalVariableGet(EnvironmentGlobalVariables.VariableNameFormat((ENUM_VBP_ENV)index[i],s));
               
               if (p==NULL) continue;
               
               if (
               NormalizeDouble(p-struct_object.level[ii].price,8)==0 || 
               (p<struct_object.level[ii].price && 
               (ii+1>=ArraySize(struct_object.level) || 
               (NormalizeDouble(p-struct_object.level[ii+1].price,8)!=0 && p>struct_object.level[ii+1].price)
               ))) {
                  
                  struct_object.level[ii].flags = struct_object.level[ii].flags | (B'1'<<i);
                  
                  struct_object.index[i] = ii;
                  
                  struct_object.price[i] = p;
                  
               }
            
            }
         
         }
      
      }    

};
