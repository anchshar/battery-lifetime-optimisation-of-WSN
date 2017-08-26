close all;
clear;
clc;
%-------------------------------
%Number of Nodes in the field
n=200;
%n=input('Enter the number of nodes in the space : ');
%Energy Model (all values in Joules)
%Initial Energy
Eo=0.1;
%Eo=input('Enter the initial energy of sensor nJ : ');
%Field Dimensions - x and y maximum (in meters)
% xm=input('Enter x value for area plot : ');
% ym=input('Enter y value for area plot : ');
xm=100;
ym=100;

%x and y Coordinates of the Sink
sink.x=1.5*xm;
sink.y=0.5*ym;

%Optimal Election Probability of a node
%to become cluster head
p=0.2;

%Eelec=Etx=Erx
ETX=50*0.000000001;
ERX=50*0.000000001;
%Transmit Amplifier types
Efs=10*0.000000000001;
Emp=0.0013*0.000000000001;
%Data Aggregation Energy
EDA=5*0.000000001;

%Values for Hetereogeneity
%Percentage of nodes than are advanced
m=0.5;
%\alpha
a=1;

%maximum number of rounds
%rmax=input('enter the number of iterations you want to run : ');
rmax=200;
%------------------

%Computation of do
do=sqrt(Efs/Emp);

%Creation of the random Sensor Network
figure(1);
hold off;
for i=1:1:n
    S(i).xd=rand(1,1)*xm;
    XR(i)=S(i).xd;
    S(i).yd=rand(1,1)*ym;
    YR(i)=S(i).yd;
    S(i).G=0;
    %initially there are no cluster heads only nodes
    S(i).type='N';
    
    temp_rnd0=i;
    %Random Election of Normal Nodes
    if (temp_rnd0>=m*n+1)
        S(i).E=Eo;
        S(i).ENERGY=0;
        plot(S(i).xd,S(i).yd,'o-r');
        hold on;
    end
    %Random Election of Advanced Nodes
    if (temp_rnd0<m*n+1)
        S(i).E=Eo*(1+a);
        S(i).ENERGY=1;
        plot(S(i).xd,S(i).yd,'+');
        hold on;
    end
end

S(n+1).xd=sink.x;
S(n+1).yd=sink.y;
plot(S(n+1).xd,S(n+1).yd,'o', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
figure(1);
% figure(1)
%  plot(o1,o2,'^','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','y', 'MarkerSize',12);
%    hold on
%First Iteration
%counter for CHs
countCHs=0;
%counter for CHs per round
rcountCHs=0;
cluster=1;

countCHs;
rcountCHs=rcountCHs+countCHs;
flag_first_dead=0;

for r=0:1:rmax
    r;
    
    %Operation for epoch
    if(mod(r, round(1/p) )==0)
        for i=1:1:n
            S(i).G=0;
            S(i).cl=0;
        end
    end
    
    hold off;
    
    %Number of dead nodes
    dead=0;
    %Number of dead Advanced Nodes
    dead_a=0;
    %Number of dead Normal Nodes
    dead_n=0;
    
    %counter for bit transmitted to Bases Station and to Cluster Heads
    packets_TO_BS=0;
    packets_TO_CH=0;
    %counter for bit transmitted to Bases Station and to Cluster Heads
    %per round
    PACKETS_TO_CH(r+1)=0;
    PACKETS_TO_BS(r+1)=0;
    
    figure(1);
    
    for i=1:1:n
        %checking if there is a dead node
        if (S(i).E<=0)
            plot(S(i).xd,S(i).yd,'^','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','y', 'MarkerSize',8);
            dead=dead+1;
            if(S(i).ENERGY==1)
                dead_a=dead_a+1;
            end
            if(S(i).ENERGY==0)
                dead_n=dead_n+1;
            end
            hold on;
        end
        if S(i).E>0
            S(i).type='N';
            if (S(i).ENERGY==0)
                plot(S(i).xd,S(i).yd,'o','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize',8);
            end
            if (S(i).ENERGY==1)
                plot(S(i).xd,S(i).yd,'+','LineWidth',3, 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize',8);
            end
            hold on;
        end
    end
    plot(S(n+1).xd,S(n+1).yd,'x','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize',8);
    
    
    STATISTICS(r+1).DEAD=dead;
    DEAD(r+1)=dead;
    DEAD_N(r+1)=dead_n;
    DEAD_A(r+1)=dead_a;
    %          plot(S(n+1).xd,S(n+1).yd,'o', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
    %          plot(S(n+1).xd,S(n+1).yd,'x','LineWidth',1, 'MarkerEdgeColor','k', 'MarkerFaceColor','r', 'MarkerSize',8);
    %When the first node dies
    if (dead==1)
        if(flag_first_dead==0)
            first_dead=r;
            flag_first_dead=1;
        end
    end
    for i=1:1:n
        S(i).mem=-5;
        S(i).neigh=5;
    end
    countCHs=0;
    cluster=1;
    for i=1:1:n
        if(S(i).E>0)
            temp_rand=rand;
            if ( (S(i).G)<=0)
                form = p / (1 + a*m);
                %form = form *(S(i).E/0.1);
                %v=sqrt((n-dead)*p - 1);
                %form=form*sqrt(S(i).neigh);
                if S(i).ENERGY == 1
                    form = form * (1 + a);
                end
                if r+1 - S(i).mem < 1/p
                    form = S(i).E/0.1 * sqrt(S(i).neigh);
                end
                %Election of Cluster Heads
                if(temp_rand <= (form/(1-form*mod(r,round(1/form)))))
                    countCHs=countCHs+1;
                    packets_TO_BS=packets_TO_BS+1;
                    PACKETS_TO_BS(r+1)=packets_TO_BS;
                    
                    S(i).type='C';
                    S(i).mem=r+1;
                    S(i).G=round(1/form)-1;
                    C(cluster).xd=S(i).xd;
                    C(cluster).yd=S(i).yd;
                    plot(S(i).xd,S(i).yd,'k*');
                    
                    distance=sqrt( (S(i).xd-(S(n+1).xd) )^2 + (S(i).yd-(S(n+1).yd) )^2 );
                    C(cluster).distance=distance;
                    C(cluster).id=i;
                    X(cluster)=S(i).xd;
                    Y(cluster)=S(i).yd;
                    cluster=cluster+1;
                    
                    %Calculation of Energy dissipated
                    distance;
                    if (distance>do)
                        S(i).E=S(i).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance ));
                        %S(i).E=S(i).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance ));
                    end
                    if (distance<=do)
                        S(i).E=S(i).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance ));
                        %S(i).E=S(i).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance ));
                    end
                    Energy_disp(r+1) =  S(i).E;
                end
                
            end
        end
    end
    
    STATISTICS(r+1).CLUSTERHEADS=cluster-1;
    CLUSTERHS(r+1)=cluster-1;
    
    %Election of Associated Cluster Head for Normal Nodes
    for i=1:1:n
        if ( S(i).type=='N' && S(i).E>0 )
            if(cluster-1>=1)
                min_dis=sqrt( (S(i).xd-S(n+1).xd)^2 + (S(i).yd-S(n+1).yd)^2 );
                min_dis_cluster=1;
                for c=1:1:cluster-1
                    temp=min(min_dis,sqrt( (S(i).xd-C(c).xd)^2 + (S(i).yd-C(c).yd)^2 ) );
                    if ( temp<min_dis )
                        min_dis=temp;
                        min_dis_cluster=c;
                    end
                end
                
                %Energy dissipated by associated Cluster Head
                min_dis;
                if (min_dis>do)
                    S(i).E=S(i).E- ( ETX*(4000) + Emp*4000*( min_dis * min_dis * min_dis * min_dis));
                end
                if (min_dis<=do)
                    S(i).E=S(i).E- ( ETX*(4000) + Efs*4000*( min_dis * min_dis));
                end
                %Energy dissipated
                if(min_dis>0)
                    distance=sqrt( (S(C(min_dis_cluster).id).xd-(S(n+1).xd) )^2 + (S(C(min_dis_cluster).id).yd-(S(n+1).yd) )^2 );
                    S(C(min_dis_cluster).id).E = S(C(min_dis_cluster).id).E- ( (ERX + EDA)*4000 );
                    if (distance>do)
                        S(C(min_dis_cluster).id).E=S(C(min_dis_cluster).id).E- ( (ETX+EDA)*(4000) + Emp*4000*( distance*distance*distance*distance ));
                    end
                    if (distance<=do)
                        S(C(min_dis_cluster).id).E=S(C(min_dis_cluster).id).E- ( (ETX+EDA)*(4000)  + Efs*4000*( distance * distance ));
                    end
                    PACKETS_TO_CH(r+1)=n-dead-cluster+1;
                end
                
                S(i).min_dis=min_dis;
                S(i).min_dis_cluster=min_dis_cluster;
                
            end
        end
    end
    hold on;
    
    countCHs;
    rcountCHs=rcountCHs+countCHs;
    sum=0;
    for i=1:1:n
        if(S(i).E>0)
            sum=sum+S(i).E;
        end
    end
    avg=sum/n;
    STATISTICS(r+1).AVG=avg;
    sum;
    
    
    %Code for Voronoi Cells
    %Unfortynately if there is a small
    %number of cells, Matlab's voronoi
    %procedure has some problems
    warning('OFF');
    [vx,vy]=voronoi(X(:),Y(:));
    plot(X,Y,'g+',vx,vy,'m-');
    hold on;
    voronoi(X,Y);
    axis([10 xm 0 ym]);
end
% figure1 = figure11;
% % Create axes
% axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on','GridLineStyle','--');
% box(axes1,'on');
% hold(axes1,'all');


% figure(2);
% for r=0:1:24
%     ylabel('Average Energy of Each Node');
%     xlabel('Round Number');
%     plot([r r+1],[STATISTICS(r+1).AVG STATISTICS(r+2).AVG],'red');
%     hold on;
% end
% figure(3);
% for r=0:1:49
%     ylabel('Average Energy of Each Node');
%     xlabel('Round Number');
%     plot([r r+1],[STATISTICS(r+1).AVG STATISTICS(r+2).AVG],'red');
%     hold on;
% end
% figure(4);
% for r=0:1:74
%     ylabel('Average Energy of Each Node');
%     xlabel('Round Number');
%     plot([r r+1],[STATISTICS(r+1).AVG STATISTICS(r+2).AVG],'red');
%     hold on;
% end
figure(2);
for r=0:1:rmax-1
    ylabel('Average Energy of Each Node');
    xlabel('Round Number');
    plot([r r+1],[STATISTICS(r+1).AVG STATISTICS(r+2).AVG],'red');
    hold on;
end
% figure(6);
% for r=0:1:24
%     ylabel('Number of Dead Nodes');
%     xlabel('Round Number');
%     plot([r r+1],[STATISTICS(r+1).DEAD STATISTICS(r+2).DEAD],'red');
%     hold on;
% end
% figure(7);
% for r=0:1:49
%         ylabel('Number of Dead Nodes');
%     xlabel('Round Number');
%     plot([r r+1],[STATISTICS(r+1).DEAD STATISTICS(r+2).DEAD],'red');
%     hold on;
% end
% figure(8);
% for r=0:1:74
%         ylabel('Number of Dead Nodes');
%     xlabel('Round Number');
%     plot([r r+1],[STATISTICS(r+1).DEAD STATISTICS(r+2).DEAD],'red');
%     hold on;
% end
figure(3);
for r=0:1:rmax-1
    ylabel('Number of Dead Nodes');
    xlabel('Round Number');
    plot([r r+1],[STATISTICS(r+1).DEAD STATISTICS(r+2).DEAD],'red');
    hold on;
end
fid=fopen('ILEACH.txt','wt');
for r=0:1:rmax-1
    fprintf( fid, '%f ',STATISTICS(r+1).AVG);
end
fprintf(fid ,'\n');
for r=0:1:rmax-1
    fprintf( fid, '%f ',STATISTICS(r+1).DEAD);
end
fprintf(fid ,'\n');