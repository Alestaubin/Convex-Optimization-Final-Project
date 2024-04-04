
function [ p, gamma ] = problemSelect( problem, b, t, i )
    switch lower(problem)
        case 'l1'
            p =@(y1) DeblurStuff.utilities.prox.l1prox( y1, b, t );
            gamma = i.gammal1;
        case 'l2'
            p =@(y1) DeblurStuff.utilities.prox.l2prox( y1, b, t );
            gamma = i.gammal2;
        otherwise
            error('Unknown problem.');
    end
end