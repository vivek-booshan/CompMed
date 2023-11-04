function [y,x,t]=SSsolve(A,B,C,D,u,tspan,x0)
[t,x]=ode23(@odefun,tspan,x0);
    function dxdt=odefun(t,x)
    dxdt = A*x+B*u;
    end
y=C*x+D*u;
end
