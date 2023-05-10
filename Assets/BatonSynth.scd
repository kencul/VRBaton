s.boot;

s.quit;

(
SynthDef.new(\lead, { |out, gate = 1,
	freq = 440, freqlag = 0.1, detun = 1.008, pan = 0,
	ffreq = 1200, ffreqMul = 3, ffreqDcy = 0.15, rq = 0.2,
	atk = 0.005, dcy = 0.2, sus = 0.6, rel = 0.1|

	// Voicer uses 'gate' for velocity
	var amp = Latch.kr(gate, gate).linlin(0, 1, 0.05, 0.25);

	var freqs = Lag.kr(freq, freqlag) * [1, detun];

	var filtEg = EnvGen.kr(Env([ffreqMul, ffreqMul, 1], [0, ffreqDcy], \exp), gate);
	var eg = EnvGen.kr(Env.adsr(atk, dcy, sus, rel), gate, doneAction: 2);

	var sig = Saw.ar(freqs).sum;

	sig = RLPF.ar(sig, (ffreq * filtEg).clip(20, 20000), rq);

	Out.ar(out, Pan2.ar(sig, pan, amp * eg));
}).add;
)

Quarks.install("ddwVoicer")

v = MonoPortaVoicer(1, \lead);
v.portaTime = 0.15;

v.trigger(60.midicps, 0.5);  // plays C
v.trigger(64.midicps, 0.5);  // glides to E

// let go of E -- glides back to C
v.release(64.midicps);

// after this, no more keys are held
// so the note fully releases
v.release(60.midicps);


//Check IP and port for OSC messaging
NetAddr.localAddr

//Post all incoming OSC messages
OSCFunc.trace(true);

OSCdef(\handle_osc_message, {|msg|
    msg.postln;
    // Process the OSC message here
}, '/address');


(
OSCdef(\on, { |address,num|
	v.trigger(num.midicps, 127);
},'/on');

OSCdef(\off, { |address,num|
	v.release(num.midicps);
},'/off');
)
