pragma circom 2.1.6;

template PowerABN(N) {
    signal input a;
    signal input b;

    signal output out;
    
    //compute (a*b)^n
    //create an array and incrementally multiply a^n and b^n
    //at the end multiply to get a^n*b^n

    signal A[N+1];
    signal B[N+1];

    A[0] <== 1;
    B[0] <== 1;

    for(var i=1; i<=N; i++){
        A[i] <== A[i-1]*a;
        B[i] <== B[i-1]*b;
    }

    out <== A[N]*B[N];
}

component main = PowerABN(32);

/* INPUT = {
    "a": "5",
    "b": "77"
} */