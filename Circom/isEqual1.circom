pragma circom 2.1.4;

template isEqual() {
    signal input in[2];
    signal output out;
    
    signal intermediate;

    intermediate <-- in[0]-in[1]? 0 : 1;
    out <== intermediate;
    0===out*(1-out);
}


component main = isEqual();

/* INPUT = {
    "in": ["10","10"]
} */