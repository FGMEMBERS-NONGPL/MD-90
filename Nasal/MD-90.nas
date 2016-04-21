# McDonnell Douglas MD-90
#
# Initialization
#
# Gary Neely aka 'Buckaroo'
#
var engine_dialog = gui.Dialog.new("Aircraft/MD-90/Systems/announcements-dialog.xml");

aircraft.livery.init("Aircraft/MD-90/Models/Liveries");
								# Set up screen message windows
var MD90_screenmssg	= screen.window.new(nil, -150, 2, 5);
var MD90_screenmssg2	= screen.window.new(nil, -180, 2, 5);

								# Lighting setup

								# Install beacon timer and controller
beacon_switch = props.globals.getNode("/controls/lighting/beacon", 1);
beacon_switch.setBoolValue(0);
aircraft.light.new("/sim/model/lighting/beacon", [0.2, 2], beacon_switch);
								# Pass beacon timer over MP (aliasing the timer value
								# doesn't seem to work, so a listener is used)
								# Use MP var float[3]
var MD90_BeaconState	= props.globals.getNode("sim/model/lighting/beacon/state[0]", 1);
var MD90_MPBeaconState	= props.globals.getNode("/sim/multiplay/generic/float[3]", 1);
setlistener(MD90_BeaconState, func {
  if (MD90_BeaconState.getBoolValue())	{ MD90_MPBeaconState.setValue(1) }
  else					{ MD90_MPBeaconState.setValue(0) }
});

var controls_nav	= props.globals.getNode("/controls/lighting/nav");
var controls_wingtipaft	= props.globals.getNode("/controls/lighting/wingtipaft");
var controls_beacon	= props.globals.getNode("/controls/lighting/beacon");
var lights_nav_toggle = func {
  MD90_screenmssg.fg = [1, 1, 1, 1];
  if (controls_nav.getValue()) {
    controls_nav.setValue(0);
    controls_wingtipaft.setValue(0);
    MD90_screenmssg.write("Nav lights off.");
  }
  else {
    controls_nav.setValue(1);
    controls_wingtipaft.setValue(1);
    MD90_screenmssg.write("Nav lights on.");
  }
}
var lights_beacon_toggle = func {
  MD90_screenmssg.fg = [1, 1, 1, 1];
  if (controls_beacon.getValue()) {
    controls_beacon.setBoolValue(0);
    MD90_screenmssg.write("Beacon lights off.");
  }
  else {
    controls_beacon.setBoolValue(1);
    MD90_screenmssg.write("Beacon lights on.");
  }
}


								# AP/AT stuff: (will live elsewhere eventually)

#autothrottle		= props.globals.getNode("/autopilot/locks/speed");
#autothrottle_mode	= props.globals.getNode("/autopilot/locks/at-mode");
#at_switch		= props.globals.getNode("/controls/switches/at");
#var autothrottle_toggle = func {
#  if (!autothrottle.getValue())	{
#    at_switch.setValue(1);					# Set switch to on position
#    if (autothrottle_mode.getValue() == 0) {			# AT mode 0 is speed
#      autothrottle.setValue("speed-with-throttle");
#    }
#    else {							# At mode 1 is mach
#      autothrottle.setValue("mach-with-throttle");
#    }
#  }
#  else {
#    autothrottle.setValue("");
#    at_switch.setValue(0);
#  }
#}


								# Establish which settings are saved on exit
var MD90_Savedata = func {
  aircraft.data.add("/controls/lighting/digital-norm");		# Numeric readouts lighting
  aircraft.data.add("/controls/lighting/pfd-norm");		# Primary flight display lighting
  aircraft.data.add("/controls/lighting/nd-norm");		# Navigational display lighting
  aircraft.data.add("/controls/lighting/panel-norm");		# Standard instrument lighting
  aircraft.data.add("/sim/instrument-options/hsi/show-rudder");	# Rudder and throttle display on HSI
}



								# Initialization:

setlistener("/sim/signals/fdm-initialized", func {
								# Start the fuel system. The MD-90 uses a customized
								# fuel routine to avoid the default cross-feed situation.
  FuelInit();					# See MD-90_fuel.nas
								# Start the custom flight surface system. The MD-90 uses
								# this to handle spoiler operations and tabbed control
								# surface simulation.
  FlightSurfaceInit();			# See MD-90_flightsurfaces.nas
  PneumaticsInit();				# See MD-90_pneumatics.nas
  InstrumentationInit();		# See MD-90_instrumentation_drivers.nas
  ap_init();					# See MD-90-autoflight.nas
  MD90_Savedata();
});



