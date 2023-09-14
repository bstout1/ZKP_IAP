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

// If index = 0, output [in[0], in[1]]
// If index =1, output [in[1], in[0]]
template DualMux() {
    signal input index;
    signal input in[2];
    signal output out[2];

    //Constrain index = 0 or 1
    0 === index*(1-index);
    out[0] <== in[0] + (in[1]-in[0])*index;
    out[1] <== in[1] + (in[0]-in[1])*index;
}

//"Merkle Tree Membership
//nLevels is the number of levels in the tree
template MTMembership(nLevels) {
    //signal input sk;
    signal input root;
    signal input siblings[nLevels];
    signal input pathIndices[nLevels]; //0 if left sibling, 1 if right sibling

    component p[nLevels];
    component muxes[nLevels];

    // Check component to make sure secret corresponds to public key
    //component check = KeyGen();
    //check.sk <== sk;

    signal input leaf;
    //leaf <== check.pk;

    signal intermediateHash[nLevels+1];

    intermediateHash[0] <== leaf;
    for (var i=0; i < nLevels; i++) {
        muxes[i] = DualMux();
        muxes[i].in[0] <== intermediateHash[i];
        muxes[i].in[1] <== siblings[i];
        muxes[i].index <== pathIndices[i];
        
        p[i] = Poseidon(2);
        p[i].inputs[0] <== muxes[i].out[0];
        p[i].inputs[1] <== muxes[i].out[1];

        intermediateHash[i+1] <== p[i].out;
    }

    root === intermediateHash[nLevels];
}

template MerkleGroupSign(nLevels) {
    signal input m;
    signal input root;
    signal input sk; // private: secret key
    signal input siblings[nLevels]; //private
    signal input pathIndices[nLevels]; // private

    component check = KeyGen();
    check.sk <== sk;

    component merkle = MTMembership(nLevels);
    merkle.root <== root;
    merkle.leaf <== check.pk;
    for (var i=0; i< nLevels; i++) {
        merkle.siblings[i] <== siblings[i];
        merkle.pathIndices[i] <== pathIndices[i];
    }

    signal mSquared;
    mSquared <== m*m;
}

//component main {public [ sk ] } = KeyGen();
component main { public [ root ] } = MTMembership(15);

/* INPUT = {
    "root": "12890874683796057475982638126021753466203617277177808903147539631297044918772",
    "leaf": "1355224352695827483975080807178260403365748530407",
    "siblings": [
        "1",
        "217234377348884654691879377518794323857294947151490278790710809376325639809",
        "18624361856574916496058203820366795950790078780687078257641649903530959943449",
        "19831903348221211061287449275113949495274937755341117892716020320428427983768",
        "5101361658164783800162950277964947086522384365207151283079909745362546177817",
        "11552819453851113656956689238827707323483753486799384854128595967739676085386",
        "10483540708739576660440356112223782712680507694971046950485797346645134034053",
        "7389929564247907165221817742923803467566552273918071630442219344496852141897",
        "6373467404037422198696850591961270197948259393735756505350173302460761391561",
        "14340012938942512497418634250250812329499499250184704496617019030530171289909",
        "10566235887680695760439252521824446945750533956882759130656396012316506290852",
        "14058207238811178801861080665931986752520779251556785412233046706263822020051",
        "1841804857146338876502603211473795482567574429038948082406470282797710112230",
        "6068974671277751946941356330314625335924522973707504316217201913831393258319",
        "10344803844228993379415834281058662700959138333457605334309913075063427817480"
    ],
    "pathIndices": [
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1",
        "1"
    ]
} */