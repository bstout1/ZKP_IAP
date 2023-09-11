pragma circom 2.1.4;

template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}

template CompConstant(ct) {
    signal input in[254];
    signal output out;

    signal parts[127];
    signal sout;

    var clsb;
    var cmsb;
    var slsb;
    var smsb;

    var sum=0;

    var b = (1 << 128) -1;
    var a = 1;
    var e = 1;
    var i;

    for (i=0;i<127; i++) {
        clsb = (ct >> (i*2)) & 1;
        cmsb = (ct >> (i*2+1)) & 1;
        slsb = in[i*2];
        smsb = in[i*2+1];

        if ((cmsb==0)&&(clsb==0)) {
            parts[i] <== -b*smsb*slsb + b*smsb + b*slsb;
        } else if ((cmsb==0)&&(clsb==1)) {
            parts[i] <== a*smsb*slsb - a*slsb + b*smsb - a*smsb + a;
        } else if ((cmsb==1)&&(clsb==0)) {
            parts[i] <== b*smsb*slsb - a*smsb + a;
        } else {
            parts[i] <== -a*smsb*slsb + a;
        }

        sum = sum + parts[i];

        b = b -e;
        a = a +e;
        e = e*2;
    }

    sout <== sum;

    component num2bits = Num2Bits(135);

    num2bits.in <== sout;

    out <== num2bits.out[127];
}

template IsNegative() {
    signal input in;
    signal output out;

    //out should be 1 if "in" is "negative" (between (p/2,p-1)) where p= babyjubjub prime

    //This number is p/2 for the babyjubjub prime. Comp is circuit with binary input array.
    //It will output 1 if in is greater than this number and 0 otherwise.
    component comp = CompConstant(10944121435919637611123202872628637544274182200208017171849102093287904247808);

    //Change "in" signal to binary
    component in_bits=Num2Bits(254);
    in_bits.in <== in;

    //Use bitified output as input to comp
    for (var i=0; i<254; i++) {
        comp.in[i]<==in_bits.out[i];
    }
    //
    out <== comp.out;
}

component main = IsNegative();

/* INPUT = {
    "in": "20944121435919637611123202872628637544274182200208017171849102093287904247808"
} */