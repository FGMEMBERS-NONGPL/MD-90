# MD-88/MD-90 Thrust Logic System by Joshua Davidson (Octal450/411)

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/controls/engines/eprlim", 1.52);
	setprop("/controls/engines/eprlimx100", 152);
	print("Thrust System ... OK!");
});