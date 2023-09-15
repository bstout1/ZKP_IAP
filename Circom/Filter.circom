pragma circom 2.1.4;

// Inputs:
// * `in` is a fixed length array of 100 tuples
// * `match` is a arbitrary input value
// Outputs:
// * `num_match` is the number of elements of `in` whose first entry 
//   matches `match`
// * the first `num_match` entries of `out` are the tuples in `in` 
//   whose first entry agrees with `match`.  the remaining entries
//   in `out` are 0-padded.

template isZero() {
    signal input in;
    signal output out;
    signal inv;

    //Check if input signal is 0. Compute inverse if so.
    inv <-- in!=0 ? (1/in):0;

    //Compute and constain output signal. if in=0, then inv=0 and in*inv=0. Otherwise in*inv=1
    out <==1-in*inv; 

    //constain that either out is 0 or in is 0
    0 === in*out;
}



template Filter() {
    signal input in[100][2];
    signal input match;
    
    signal diff[100];
    component checkZero[100];

    signal output num_match;
    signal output m[100][4];
    signal output out[100][2];

    //This loop subtracts match from each first coordinate and uses isZero to check if the first component is zero
    //This results in array "m" having 1 in entry i when the first coordinate of entry i in "in" matches "match"
    //"out" will store a (0,0) if there is no match and (in1, in2) if in1=match, but is not shifted yet.
    //
    for (var i=0; i<100; i++){
        diff[i] <== in[i][0] - match;
        checkZero[i]=isZero();
        checkZero[i].in <== diff[i];
        m[i][0]<==checkZero[i].out;
        m[i][1] <== i*m[i][0];
        m[i][2] <== in[i][0] * m[i][0];
        m[i][3] <== in[i][1] * m[i][0]
;    }

   //This loop counts the number of 1 entries in "m" giving the match total num_match
    signal sum[101];
    sum[0]<==0;
    for (var i=1; i<101; i++){
        sum[i]<==sum[i-1]+m[i-1][0];
    }
    num_match <== sum[100]; 
    
}
component main = Filter();

/* INPUT = {
    "in": [
        [
            6,
            8
        ],
        [
            7,
            6
        ],
        [
            10,
            7
        ],
        [
            7,
            5
        ],
        [
            2,
            9
        ],
        [
            8,
            6
        ],
        [
            9,
            4
        ],
        [
            2,
            7
        ],
        [
            7,
            6
        ],
        [
            8,
            1
        ],
        [
            5,
            5
        ],
        [
            3,
            9
        ],
        [
            4,
            9
        ],
        [
            3,
            4
        ],
        [
            10,
            5
        ],
        [
            1,
            10
        ],
        [
            2,
            10
        ],
        [
            7,
            3
        ],
        [
            10,
            4
        ],
        [
            9,
            5
        ],
        [
            6,
            9
        ],
        [
            7,
            8
        ],
        [
            10,
            5
        ],
        [
            1,
            7
        ],
        [
            9,
            7
        ],
        [
            9,
            8
        ],
        [
            5,
            4
        ],
        [
            9,
            8
        ],
        [
            2,
            2
        ],
        [
            5,
            3
        ],
        [
            1,
            5
        ],
        [
            1,
            9
        ],
        [
            1,
            3
        ],
        [
            6,
            6
        ],
        [
            10,
            1
        ],
        [
            1,
            7
        ],
        [
            6,
            9
        ],
        [
            4,
            3
        ],
        [
            9,
            8
        ],
        [
            7,
            9
        ],
        [
            2,
            10
        ],
        [
            3,
            6
        ],
        [
            5,
            6
        ],
        [
            8,
            5
        ],
        [
            9,
            2
        ],
        [
            3,
            1
        ],
        [
            5,
            4
        ],
        [
            2,
            4
        ],
        [
            5,
            7
        ],
        [
            2,
            4
        ],
        [
            7,
            7
        ],
        [
            4,
            10
        ],
        [
            7,
            9
        ],
        [
            8,
            10
        ],
        [
            2,
            2
        ],
        [
            6,
            8
        ],
        [
            10,
            10
        ],
        [
            5,
            2
        ],
        [
            4,
            4
        ],
        [
            3,
            3
        ],
        [
            4,
            4
        ],
        [
            3,
            7
        ],
        [
            1,
            5
        ],
        [
            10,
            1
        ],
        [
            7,
            10
        ],
        [
            8,
            9
        ],
        [
            8,
            3
        ],
        [
            9,
            1
        ],
        [
            7,
            4
        ],
        [
            2,
            4
        ],
        [
            8,
            7
        ],
        [
            2,
            5
        ],
        [
            1,
            8
        ],
        [
            5,
            6
        ],
        [
            2,
            3
        ],
        [
            3,
            8
        ],
        [
            10,
            5
        ],
        [
            8,
            9
        ],
        [
            8,
            1
        ],
        [
            3,
            8
        ],
        [
            5,
            10
        ],
        [
            7,
            4
        ],
        [
            7,
            1
        ],
        [
            4,
            9
        ],
        [
            6,
            1
        ],
        [
            7,
            6
        ],
        [
            6,
            2
        ],
        [
            7,
            10
        ],
        [
            3,
            7
        ],
        [
            4,
            3
        ],
        [
            4,
            6
        ],
        [
            4,
            1
        ],
        [
            3,
            7
        ],
        [
            7,
            8
        ],
        [
            3,
            10
        ],
        [
            2,
            8
        ],
        [
            4,
            9
        ],
        [
            2,
            10
        ],
        [
            7,
            5
        ],
        [
            9,
            1
        ]
    ],
    "match": "5"
} */