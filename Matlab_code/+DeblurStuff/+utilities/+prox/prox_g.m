%Will compute prox_g for both l1 and l2

function prox_output = prox_g(norm, b, i, y, t)
    arguments
        norm (1,:) char
        b (:,:) double
        i struct
        y (:,:,3) double
        t double
    end

    %split y in two parts (this is actually split in 3, since the isonorm also splits in two)
    ynorm = y(:,:,1);
    yiso = y(:,:,2:3);

    %computing the prox depending on desired norm (l1 or l2)

    switch norm
        case 'l1'
            gamma_norm = i.gammal1;
            prox_norm = DeblurStuff.utilities.prox.l1prox(ynorm, t, b);
        case 'l2'
            gamma_norm = i.gammal2;
            prox_norm = DeblurStuff.utilities.prox.l2prox(ynorm, t, b);
    end

    %coomputing iso prox
    prox_iso = DeblurStuff.utilities.prox.isoprox(yiso,t*gamma_norm);

    %grouping it together
    prox_output = cat(3, prox_norm, prox_iso);
end
