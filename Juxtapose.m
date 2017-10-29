fileID = fopen('ILEACH.txt','r');
A = fscanf(fileID,'%f ');
disp(A);
disp(size(A));
ILEACHA=A(1:200);
ILEACHB=A(201:400);

fileID = fopen('ILEACH2.txt','r');
A = fscanf(fileID,'%f ');
disp(A);
disp(size(A));
ILEACH2A=A(1:200);
ILEACH2B=A(201:400);

fileID = fopen('LEACHGUI.txt','r');
A = fscanf(fileID,'%f ');
disp(A);
disp(size(A));
LEACHGUIA=A(1:200);
LEACHGUIB=A(201:400);

rmax=200;
figure(1);

for r=0:1:rmax-2
    ylabel('Average Energy');
    xlabel('Round Number');
    if(mod(r,10)==0)
        plot([r r+1],[ILEACHA(r+1) ILEACHA(r+2)],'*','Color','red');
        plot([r r+1],[ILEACH2A(r+1) ILEACH2A(r+2)],'x','Color','blue');
        plot([r r+1],[LEACHGUIA(r+1) LEACHGUIA(r+2)],'o','Color','green');
    else
        plot([r r+1],[ILEACHA(r+1) ILEACHA(r+2)],'Color','red');
        plot([r r+1],[ILEACH2A(r+1) ILEACH2A(r+2)],'blue');
        plot([r r+1],[LEACHGUIA(r+1) LEACHGUIA(r+2)],'green');
    end
    hold on;
end
x=[140,160];
y=[.14,.14];
plot(x,y,'green');
x=[140,160];
y=[0.13,0.13];
plot(x ,y, 'red');
x=[140,160];
y=[0.12,0.12];
plot(x ,y, 'blue');
text(163,0.14  , 'LEACH', 'Color', 'green', 'FontWeight', 'bold');hold on;
text(163,0.13  , 'ILEACH', 'Color', 'red', 'FontWeight', 'bold');hold on;
text(163,0.12, 'OHILEACH', 'Color', 'blue', 'FontWeight', 'bold');hold on;
hold off;
figure(2);
for r=0:1:rmax-2
    ylabel('Dead Nodes');
    xlabel('Round Number');
    if(mod(r,10)==0)
        plot([r r+1],[ILEACHB(r+1) ILEACHB(r+2)],'*','Color','red');
        plot([r r+1],[ILEACH2B(r+1) ILEACH2B(r+2)],'x','Color','blue');
        plot([r r+1],[LEACHGUIB(r+1) LEACHGUIB(r+2)],'o','Color','green');
    else
    plot([r r+1],[ILEACHB(r+1) ILEACHB(r+2)],'Color','red');
    plot([r r+1],[ILEACH2B(r+1) ILEACH2B(r+2)],'blue');
    plot([r r+1],[LEACHGUIB(r+1) LEACHGUIB(r+2)],'green');
    end
    hold on;
end
x=[15 33];
y=[140 140];
plot(x ,y ,'Color','red');
x=[15 33];
y=[150 150];
plot(x ,y ,'Color','blue');
x=[15 33];
y=[130 130];
plot(x ,y ,'Color','green');
text(35,130  , 'LEACH', 'Color', 'green', 'FontWeight', 'bold');hold on;
text(35,140  , 'ILEACH', 'Color', 'red', 'FontWeight', 'bold');hold on;
text(35,150  , 'OHILEACH', 'Color', 'blue', 'FontWeight', 'bold');hold on;