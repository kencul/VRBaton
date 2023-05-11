

s.boot;

s.quit;

Quarks.install("ddwVoicer");

//MONO SYNTH
//REF: https://scsynth.org/t/how-in-the-func-do-you-make-a-monophonic-midi-synth/3940

(
SynthDef.new(\lead, { |out, gate = 1,
	freq = 440, freqlag = 0.1, detun = 1.008, pan = 0,
	ffreq = 1200, ffreqMul = 3, ffreqDcy = 0.15, rq = 0.2,
	atk = 0.005, dcy = 0.2, sus = 0.6, rel = 0.1, oscfreq = 1500, vib = 0|

	// Voicer uses 'gate' for velocity

	//var input;
	var amp = Latch.kr(gate, gate).linlin(0, 1, 0.05, 0.25);

	var freqs = Lag.kr(freq, freqlag) * [1, detun];

	var filtEg = EnvGen.kr(Env([ffreqMul, ffreqMul, 1], [0, ffreqDcy], \exp), gate);
	var eg = EnvGen.kr(Env.adsr(atk, dcy, sus, rel), gate, doneAction: 2);

	//vibrato
	var sig = Saw.ar(freqs + SinOsc.kr(8, 0, vib)).sum;

	sig = RLPF.ar(sig, (ffreq * filtEg).clip(20, 20000), rq);

	//input = AllpassC.ar(sig, 0.04, { Rand(0.001,0.04) }.dup, 3);
	//16.do({ input = AllpassC.ar(input, 0.04, { Rand(0.001,0.04) }.dup, 3)});

	Out.ar(out, RLPF.ar(Pan2.ar(sig, pan, amp * eg), oscfreq.clip(20,20000), rq));
	//Out.ar(out, Pan2.ar(sig, pan, amp * eg));
}).add;




v = MonoPortaVoicer(1, \lead);
v.portaTime = 0.15;
v.mapGlobal(\pan, nil, 0, [-200,200]);
v.mapGlobal(\oscfreq, nil, 1000, [20,20000]);
v.mapGlobal(\vib, nil, 0, [0,30]);
)

v.trigger(60.midicps, 0.5);  // plays C
v.trigger(64.midicps, 0.5);  // glides to E

v.set(\freq, 550)

// let go of E -- glides back to C
v.release(64.midicps);
v.release(60.midicps);
v.panic
v.releaseAll;

//OSC FUNCTIONS
//REF: https://doc.sccode.org/Guides/OSC_communication.html


//Check IP and port for OSC messaging
NetAddr.localAddr

//Post all incoming OSC messages
OSCFunc.trace(false);
(
f = { |msg, time, addr|
    if(msg[0] != '/status.reply') {
        "time: % sender: %\nmessage: %\n".postf(time, addr, msg);
    }
};
thisProcess.addOSCRecvFunc(f);
)

// stop posting.
thisProcess.removeOSCRecvFunc(f);




//OSC PROCESSING
(
OSCdef(\on, { |msg|
	v.trigger(msg[1].midicps, 0.5);
},'/on');

OSCdef(\off, { |msg|
	v.release(msg[1].midicps);
},'/off');

OSCdef(\panic, { |msg|
	v.releaseAll;
},'/panic');

OSCdef(\pan, {|msg|
	v.set([\pan,msg[1]]);
},'/pan');

OSCdef(\oscfreq, {|msg|
	v.set([\oscfreq,msg[1]]);
},'/oscfreq');

OSCdef(\vib, {|msg|
	v.set([\vib,msg[1]]);
},'/vib');
)
//show osc defs
OSCdef.all;
//clear osc defs
OSCdef.freeAll;


//ARGUMENT MODS

//exposing arguments
v.mapGlobal(\ffreq, nil, 1200, [0, 2000]);
v.mapGlobal(\freq, nil, 20 , [430, 450]);


v.set([\pan,0]);


v.free