clear all;close all;
%add all these jars present in your gps directory to path
javaaddpath /usr/local/share/java/lcm.jar
javaaddpath /home/lucas/Downloads/my_types.jar
%javaaddpath /home/lucas/Downloads/lab1_t.jar

%change your log file path in your current matlab workspace

log_file = lcm.logging.Log('/home/lucas/Downloads/log/lcm-log-2019-01-29-20:29:15', 'r')

%log_file = lcm.logging.Log('/home/lucas/Downloads/log/lcm-log-2019-01-29-20:42:44', 'r')
disp("2");


while true
 try
        
        alt = zeros(1,1000);
        timestamp = zeros(1,10000);
        long = zeros(1,10000);
        lat= zeros(1,10000);
        utm_n = zeros(1,10000);
        utm_e = zeros(1,10000);
        disp("end");
    for i=1:10000 
          
           ev = log_file.readNext(); 
         
            
           % there may be multiple channels but in this case you are only interested in RDI channel
% use hw2 to play around using data in my log files. if not feel free to use GPS OR any other publisher

           if strcmp(ev.channel, 'GPS')
            % build rdi object from data in this record
              msg = gps.gps_types(ev.data);
              disp("1");
            
              alt(i) = msg.altitude;
              timestamp(i)=msg.timestamp;
              long(i)=msg.longitude;
              lat(i)=msg.latitude;
              utm_e(i)=msg.utmeasting;
              utm_n(i)=msg.utmnorthing;
           end
    end
   catch err   % exception will be thrown when you hit end of file
         break;
   
 end
end
%plot(utm_n,utm_e,'*')
utm_n1=(utm_n)'-4689499;
utm_e1=(utm_e)'-671967.8; 
plot(utm_n1,utm_e1,'*');
xlabel("utm_n");
ylabel("utm_e");


