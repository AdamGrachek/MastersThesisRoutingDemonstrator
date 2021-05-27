function [MyWay10, MyWay25, VC10, VC25] = databasecall()

%%  Adding the JDBC driver to the classpath.
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

% Obtain vectors of PM 10 and PM2.5 for each location separately
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

conn.close; % Closes the connection to the database
end