function [MyWay10, MyWay25, VC10, VC25] = databasecall()

%%  Adding the JDBC driver to the classpath.
%   This only needs to be done once per MATLAB session.
javaaddpath('postgresql-42.2.20.jar')

%%  Setting connection parameters.
databasename = 'kungsgatan';
username = %USERNAME
password = %PASSWORD
driver = 'org.postgresql.Driver';
url = 'jdbc:postgresql://localhost:5455/kungsgatan';

%% Opens a connection to the database.

conn = database(databasename,username,password,driver,url);

%%  Query for running recurrent queries
%   This method is good when you want to run multiple queries with some 
%   changes such as time windows or ids. It is most used when the dataset
%   is to large or when you do not want all the data at the same time.
%   The difference between this method and the one above is that the 
%   database makes a query plan each time it gets a query, however in this 
%   case the databse stores the queryplan for multiple queries.

% query = ['SELECT device_name, timestamp, pm_10, pm_25 ', ...
%          'FROM tnk116.pm ', ...
%          'WHERE device_name = ? ', ...
%          'AND timestamp > now() - Interval ''60 minutes'''];
% 
query = ['SELECT device_name, timestamp, pm_10, pm_25 ', ...
         'FROM tnk116.pm ', ...
         'WHERE device_name = ? ', ...
         'AND timestamp >= ''2021-03-23 06:00:00'' AND timestamp < ''2021-03-23 12:00:00'''];
     

     
     
statement = databasePreparedStatement(conn,query);

% VISUALIZATION CENTER SENSOR
device = 5;
statement.bindParamValues(1,num2str(device));
data5 = fetch(conn,statement);

% MYWAY SENSOR
device = 6;
statement.bindParamValues(1,num2str(device));
data6 = fetch(conn,statement);

data5(:,1:2)=[];
data6(:,1:2)=[];
data5=table2array(data5);
data6=table2array(data6);




%Obtain vectors of PM 10 and PM2.5 for each location separately
MyWay10=data5(:,1);
MyWay25=data5(:,2);
VC10=data6(:,1);
VC25=data6(:,2);

% Remove empty values
if(isempty(data5))
    MyWay10 = 0;
    MyWay25 = 0;
end

if(isempty(data6))
    VC10 = 0;
    VC25 = 0;
end

% for device = 5:6
%     fprintf(['Example of prepared statement that fetches particles' , ...
%              'from device %d.\n'],device);
%     statement.bindParamValues(1,num2str(device));
%     data = fetch(conn,statement)
% end

fprintf('Closing the connection.\n')
conn.close;
end