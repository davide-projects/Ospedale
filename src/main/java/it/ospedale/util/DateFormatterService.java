package it.ospedale.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class DateFormatterService {

    private static final DateTimeFormatter ITALIAN_SHORT =
            DateTimeFormatter.ofPattern("dd/MM/yyyy", Locale.ITALIAN);

    private static final DateTimeFormatter ITALIAN_LONG =
            DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.ITALIAN);

    public static String formatShort(LocalDate date) {
        return date != null ? date.format(ITALIAN_SHORT) : "";
    }

    public static String formatLong(LocalDate date) {
        return date != null ? date.format(ITALIAN_LONG) : "";
    }
}
