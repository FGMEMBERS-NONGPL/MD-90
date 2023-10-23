# MD-88/MD-90 Thrust Logic System by Joshua Davidson (Octal450/411)

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/controls/engines/eprlim", 1.34);
	setprop("/controls/engines/eprlimx100", 134);
	print("Thrust System ... OK!");
});