pragma circom 2.1.4;

include "circomlib/poseidon.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template KeyGen () {
    //Computes and constrains a public key from a private key using Poseidon hash fn
    signal input sk;
    signal output pk;

    component p = Poseidon(1);
    p.inputs[0] <== sk;
    pk <== p.out;

}

template Sign() {
    //Sign a message m using private key. Checks that it matches public key.
    signal input m;
    signal input sk;
    signal input pk;

    component check = KeyGen();
    check.sk <== sk;
    pk === check.pk;

    //??
    signal mSquared;
    mSquared <== m*m;
}

//"n" is the number of people in the group
template GroupSign(n) {
    signal input m;
    signal input sk;
    signal input pk[n];

    // Check component to make sure secret corresponds to public key
    component check = KeyGen();
    check.sk <== sk;
    //Now check it matches one of the signals in the array pk;

    signal zeroCheck[n+1];
    zeroCheck[0]<==1;
    for (var i=0; i < n; i++) {
        zeroCheck[i+1]<==zeroCheck[i]*(pk[i]-check.pk);
    }
    zeroCheck[n] === 0;

    signal mSquared;
    mSquared <== m*m;

}

//component main {public [ sk ] } = KeyGen();
component main { public [ m, pk ] } = GroupSign(5);

/* INPUT = {
    "m": "63",
    "sk": "3",
    "pk": ["6018413527099068561047958932369318610297162528491556075919075208700178480084",
            "2",
            "3",
            "4",
            "5" ]
} */