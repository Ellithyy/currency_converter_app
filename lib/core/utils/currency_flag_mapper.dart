class CurrencyFlagMapper {
  CurrencyFlagMapper._();

  static const Map<String, String> _currencyToCountry = {
    'AED': 'ae', 'AUD': 'au', 'BDT': 'bd', 'BHD': 'bh',
    'BRL': 'br', 'CAD': 'ca', 'CHF': 'ch', 'CLP': 'cl',
    'CNY': 'cn', 'COP': 'co', 'CZK': 'cz', 'DKK': 'dk',
    'EGP': 'eg', 'EUR': 'eu', 'GBP': 'gb', 'HKD': 'hk',
    'HUF': 'hu', 'IDR': 'id', 'ILS': 'il', 'INR': 'in',
    'IQD': 'iq', 'IRR': 'ir', 'ISK': 'is', 'JOD': 'jo',
    'JPY': 'jp', 'KRW': 'kr', 'KWD': 'kw', 'LBP': 'lb',
    'LKR': 'lk', 'MAD': 'ma', 'MXN': 'mx', 'MYR': 'my',
    'NGN': 'ng', 'NOK': 'no', 'NZD': 'nz', 'OMR': 'om',
    'PHP': 'ph', 'PKR': 'pk', 'PLN': 'pl', 'QAR': 'qa',
    'RON': 'ro', 'RUB': 'ru', 'SAR': 'sa', 'SEK': 'se',
    'SGD': 'sg', 'THB': 'th', 'TRY': 'tr', 'TWD': 'tw',
    'UAH': 'ua', 'USD': 'us', 'VND': 'vn', 'ZAR': 'za',
  };

  static String getFlagUrl(String currencyCode) {
    final country =
        _currencyToCountry[currencyCode.toUpperCase()] ??
        currencyCode.substring(0, 2).toLowerCase();
    return 'https://flagcdn.com/$country.svg';
  }
}
