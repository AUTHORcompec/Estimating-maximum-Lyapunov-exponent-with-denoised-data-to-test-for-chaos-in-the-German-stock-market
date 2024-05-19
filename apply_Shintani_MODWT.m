
clear;

clc

 fprintf('Shintani test results:\n')
 

 fprintf('Without noise reduction (raw data):\n')

    load adidas.txt;
    x=adidas;
    fprintf('adidas:\n')

    [H,p,lambda,Orders]=ShintaniFull(x,'SIGMOID',[7,8,7]);

	fprintf('Full sample:\n')
  	H
	lambda
	p

    [H,p,lambda,Orders]=ShintaniBlock(x,'SIGMOID',[7,8,7]);

	fprintf('Block:\n')
  	H
	lambda
	median(p)


    [H,p,lambda,Orders]=ShintaniEQS(x,'SIGMOID',[7,8,7]);

	fprintf('Equally spaced:\n')
  	H
	lambda
	p
	


 fprintf('With noise reduction:\n')


     load adidas.TXT;
    x=adidas;
    fprintf('adidas:\n')

 	num=floor(log2(size(x,1)));
    %w=modwt(x,'haar',num);
    %xdMODWT = wden(w,'modwtsqtwolog','s','mln',num,'haar');
    w=modwt(x,'coif2',num);
    xs = wden(w,'modwtsqtwolog','s','mln',num,'coif2');
  	
    [H,p,lambda,Orders]=ShintaniFull(xs,'SIGMOID',[7,8,7]);

	fprintf('Full sample:\n')
  	H
	lambda
	p

    [H,p,lambda,Orders]=ShintaniBlock(xs,'SIGMOID',[7,8,7]);

	fprintf('Block:\n')
  	H
	lambda
	p


    [H,p,lambda,Orders]=ShintaniEQS(xs,'SIGMOID',[7,8,7]);

	fprintf('Equally spaced:\n')
  	H
	lambda
	p