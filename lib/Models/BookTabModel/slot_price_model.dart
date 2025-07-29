class SlotPriceModel {
  final int venueId;
  final String venueName;
  final String venueStartTime;
  final String venueEndTime;
  final int minimumMinutesSport;
  final int sportId;
  final String sportName;
  final Map<String, List<SlotPrice>> slotsPrice;
  final Map<String, List<CalendarSlot>> calendarSlots;
  final List<AvailableSlotDate> availableSlots;

  SlotPriceModel({
    required this.venueId,
    required this.venueName,
    required this.venueStartTime,
    required this.venueEndTime,
    required this.minimumMinutesSport,
    required this.sportId,
    required this.sportName,
    required this.slotsPrice,
    required this.calendarSlots,
    required this.availableSlots,
  });

  factory SlotPriceModel.fromJson(Map<String, dynamic> json) {
    final slotsPriceRaw = json['slots_price'] as Map<String, dynamic>? ?? {};
    final calendarSlotsRaw =
        json['calendar_slots'] as Map<String, dynamic>? ?? {};
    final availableSlotsRaw = json['available_slots'] as List<dynamic>? ?? [];
    return SlotPriceModel(
      venueId: json['venue_id'] ?? 0,
      venueName: json['venue_name'] ?? '',
      venueStartTime: json['venue_start_time'] ?? '',
      venueEndTime: json['venue_end_time'] ?? '',
      minimumMinutesSport: json['minimun_minutes_sport'] ?? 0,
      sportId: json['sport_id'] ?? 0,
      sportName: json['sport_name'] ?? '',
      slotsPrice: slotsPriceRaw.map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => SlotPrice.fromJson(e)).toList(),
        ),
      ),
      calendarSlots: calendarSlotsRaw.map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => CalendarSlot.fromJson(e)).toList(),
        ),
      ),
     availableSlots: (json['available_slots'] as List<dynamic>?)
              ?.map((e) => AvailableSlotDate.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class SlotPrice {
  final int slotId;
  final String startTime;
  final String endTime;
  final int rate;
  final String slotUnitType;
  final String slotType;
  final int serviceId;
  final String slotName;

  SlotPrice({
    required this.slotId,
    required this.startTime,
    required this.endTime,
    required this.rate,
    required this.slotUnitType,
    required this.slotType,
    required this.serviceId,
    required this.slotName,
  });

  factory SlotPrice.fromJson(Map<String, dynamic> json) {
    return SlotPrice(
      slotId: json['slot_id'] ?? 0,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      rate: json['rate'] ?? 0,
      slotUnitType: json['slot_unit_type'] ?? '',
      slotType: json['slot_type'] ?? '',
      serviceId: json['service_id'] ?? 0,
      slotName: json['slot_name'] ?? '',
    );
  }
}

class CalendarSlot {
  final int calendarId;
  final int unitId;
  final String unitName;
  final String day;
  final String startTimeSlot;
  final String endTimeSlot;
  final int slotId;
  final int periodId;
  final String periodStartDate;
  final String periodEndDate;

  CalendarSlot({
    required this.calendarId,
    required this.unitId,
    required this.unitName,
    required this.day,
    required this.startTimeSlot,
    required this.endTimeSlot,
    required this.slotId,
    required this.periodId,
    required this.periodStartDate,
    required this.periodEndDate,
  });

  factory CalendarSlot.fromJson(Map<String, dynamic> json) {
    return CalendarSlot(
      calendarId: json['calendar_id'] ?? 0,
      unitId: json['unit_id'] ?? 0,
      unitName: json['unit_name'] ?? '',
      day: json['day'] ?? '',
      startTimeSlot: json['start_time_slot'] ?? '',
      endTimeSlot: json['end_time_slot'] ?? '',
      slotId: json['slot_id'] ?? 0,
      periodId: json['period_id'] ?? 0,
      periodStartDate: json['period_start_date'] ?? '',
      periodEndDate: json['period_end_date'] ?? '',
    );
  }
}

//3
class AvailableSlotDate {
  final String date;
  final List<AvailableSlot> slots;

  AvailableSlotDate({required this.date, required this.slots});

  factory AvailableSlotDate.fromJson(Map<String, dynamic> json) {
    return AvailableSlotDate(
      date: json['date'] ?? '',
      slots:
          (json['slots'] as List<dynamic>?)
              ?.map((e) => AvailableSlot.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AvailableSlot {
  final String timeRange;
  final List<Unit> availableUnits;

  AvailableSlot({required this.timeRange, required this.availableUnits});

  factory AvailableSlot.fromJson(Map<String, dynamic> json) {
    return AvailableSlot(
      timeRange: json['timeRange'] ?? '',
      availableUnits:
          (json['availableUnits'] as List<dynamic>?)
              ?.map((e) => Unit.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Unit {
  final int unitId;
  final String unitName;

  Unit({required this.unitId, required this.unitName});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      unitId: json['unit_id'] ?? 0,
      unitName: json['unit_name'] ?? '',
    );
  }
}

//--
