enum VenueCategory {
  wedding,
  conference,
  party,
  sports,
  indoor,
  outdoor
}

// Extension to convert enum to string for display
extension VenueCategoryExtension on VenueCategory {
  String get name {
    switch (this) {
      case VenueCategory.wedding:
        return 'Wedding';
      case VenueCategory.conference:
        return 'Conference';
      case VenueCategory.party:
        return 'Parties';
      case VenueCategory.sports:
        return 'Sports';
      case VenueCategory.indoor:
        return 'Indoor';
      case VenueCategory.outdoor:
        return 'Outdoor';
    }
  }

  static VenueCategory fromString(String category) {
    switch (category.toLowerCase()) {
      case 'wedding':
        return VenueCategory.wedding;
      case 'conference':
        return VenueCategory.conference;
      case 'parties':
        return VenueCategory.party;
      case 'sports':
        return VenueCategory.sports;
      case 'indoor':
        return VenueCategory.indoor;
      case 'outdoor':
        return VenueCategory.outdoor;
      default:
        throw Exception('Invalid category');
    }
  }
}
