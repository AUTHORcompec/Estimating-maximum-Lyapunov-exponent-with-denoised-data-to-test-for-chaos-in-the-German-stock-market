
function [x,y,z,b] = rossler(N, level, a, b, c,w,dynamic_noise)

% Simulate the Rossler system described in Rossler (1976), "An equation for
% continuous chaos" using a fourth-order Runge Kutta method

% Inputs
% N - number of time-points to simulate
%
% level - the amplitude of white noise to add to the final signals,
% relative to the standard deviation of those signals (e.g. level=0.2 will
% add white noise, the amplitude of which is 20% the standard deviation of
% each component of the Rossler system
%
% a, b, c - parameters of the Rossler system. For the chaotic
% simulation of Table 4, a=.2, b=.2, and c=5.7

% w - the frequency of the Rossler system oscillations (in the paper, w=1)

% random initial conditions
x(1)=rand;
y(1)=rand;
z(1)=rand;

% time points, with an integration step of 0.01
h=.01;   %step size
t=0: h:  (500*(N-1)*h+  150000*h);

% ordinary differential equations
f=@(t,x,y,z,w) -w.*y-z;
g=@(t,x,y,z,w) w.*x+a*y;
p=@(t,x,y,z) b+z.*(x-c);

% Simulate
for i=1:(length(t)-1)
    k1=f(t(i),x(i),y(i),z(i),w);
    l1=g(t(i),x(i),y(i),z(i),w);
    m1=p(t(i),x(i),y(i),z(i));
      k2=f(t(i)+h/2,(x(i)+0.5*k1*h),(y(i)+(0.5*l1*h)),(z(i)+(0.5*m1*h)),w);     
      l2=g(t(i)+h/2,(x(i)+0.5*k1*h),(y(i)+(0.5*l1*h)),(z(i)+(0.5*m1*h)),w);
      m2=p(t(i)+h/2,(x(i)+0.5*k1*h),(y(i)+(0.5*l1*h)),(z(i)+(0.5*m1*h)));
      
      k3=f(t(i)+h/2,(x(i)+0.5*k2*h),(y(i)+(0.5*l2*h)),(z(i)+(0.5*m2*h)),w);
      l3=g(t(i)+h/2,(x(i)+0.5*k2*h),(y(i)+(0.5*l2*h)),(z(i)+(0.5*m2*h)),w);
      m3=p(t(i)+h/2,(x(i)+0.5*k2*h),(y(i)+(0.5*l2*h)),(z(i)+(0.5*m2*h)));
      
      k4=f(t(i)+h,(x(i)+k3*h),(y(i)+l3*h),(z(i)+m3*h),w);
      l4=g(t(i)+h,(x(i)+k3*h),(y(i)+l3*h),(z(i)+m3*h),w);
      m4=p(t(i)+h,(x(i)+k3*h),(y(i)+l3*h),(z(i)+m3*h));
      x(i+1) = x(i) + h*(k1 +2*k2  +2*k3   +k4)/6+dynamic_noise*randn; %final equations
      y(i+1) = y(i) + h*(l1  +2*l2   +2*l3    +l4)/6;
      z(i+1) = z(i) + h*(m1+2*m2 +2*m3  +m4)/6;
end

% discard initial settling period
x=x(150001:end);
z=z(150001:end);
y=y(150001:end);

x=downsample(x,500);
y=downsample(y,500);
z=downsample(z,500);

% take linear combination of x and y components of system
b=x+y;


% add white noise
l=length(x);
x=x+randn(1,l)*level*std(x);
y=y+randn(1,l)*level*std(y);
z=z+randn(1,l)*level*std(z);
b=b+randn(1,l)*level*std(b);
