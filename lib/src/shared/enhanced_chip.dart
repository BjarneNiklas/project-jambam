import 'package:flutter/material.dart';

/// Enhanced Chip Widget mit verbesserter visueller Hervorhebung für ausgewählte Zustände
class EnhancedChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;
  final IconData? selectedIcon;
  final Color? selectedColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final TextStyle? labelStyle;
  final bool showCheckmark;
  final bool isMultiSelect;

  const EnhancedChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.onSelected,
    this.icon,
    this.selectedIcon,
    this.selectedColor,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.padding,
    this.labelStyle,
    this.showCheckmark = true,
    this.isMultiSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Dynamische Farben basierend auf Auswahlzustand
    final effectiveSelectedColor = selectedColor ?? colorScheme.primary;
    final effectiveBackgroundColor = isSelected 
        ? effectiveSelectedColor.withValues(alpha: 0.15)
        : backgroundColor ?? colorScheme.surfaceContainerHighest;
    final effectiveBorderColor = isSelected 
        ? effectiveSelectedColor 
        : borderColor ?? colorScheme.outline.withValues(alpha: 0.3);
    final effectiveTextColor = isSelected 
        ? effectiveSelectedColor 
        : colorScheme.onSurface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? (onSelected != null ? () => onSelected!(true) : null),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              border: Border.all(
                color: effectiveBorderColor,
                width: isSelected ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: effectiveSelectedColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon (wenn vorhanden)
                if (icon != null || selectedIcon != null) ...[
                  Icon(
                    isSelected ? (selectedIcon ?? icon) : icon,
                    size: 16,
                    color: isSelected ? effectiveSelectedColor : effectiveTextColor,
                  ),
                  const SizedBox(width: 6),
                ],
                
                // Label
                Text(
                  label,
                  style: labelStyle?.copyWith(
                    color: effectiveTextColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ) ?? TextStyle(
                    color: effectiveTextColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
                
                // Checkmark für Multi-Select
                if (isSelected && showCheckmark && isMultiSelect) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: effectiveSelectedColor,
                  ),
                ],
                
                // Checkmark für Single-Select
                if (isSelected && showCheckmark && !isMultiSelect) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: effectiveSelectedColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Enhanced FilterChip für Multi-Select-Funktionalität
class EnhancedFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;
  final IconData? selectedIcon;
  final Color? selectedColor;
  final Color? backgroundColor;
  final bool showCheckmark;

  const EnhancedFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.selectedIcon,
    this.selectedColor,
    this.backgroundColor,
    this.showCheckmark = true,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedChip(
      label: label,
      isSelected: selected,
      onSelected: onSelected,
      icon: icon,
      selectedIcon: selectedIcon,
      selectedColor: selectedColor,
      backgroundColor: backgroundColor,
      showCheckmark: showCheckmark,
      isMultiSelect: true,
    );
  }
}

/// Enhanced ChoiceChip für Single-Select-Funktionalität
class EnhancedChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final IconData? icon;
  final IconData? selectedIcon;
  final Color? selectedColor;
  final Color? backgroundColor;

  const EnhancedChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.icon,
    this.selectedIcon,
    this.selectedColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedChip(
      label: label,
      isSelected: selected,
      onSelected: onSelected,
      icon: icon,
      selectedIcon: selectedIcon,
      selectedColor: selectedColor,
      backgroundColor: backgroundColor,
      isMultiSelect: false,
    );
  }
}

/// Enhanced ActionChip für Aktionen
class EnhancedActionChip extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;

  const EnhancedActionChip({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedChip(
      label: label,
      isSelected: false,
      onTap: onPressed,
      icon: icon,
      selectedColor: color,
      backgroundColor: backgroundColor,
      showCheckmark: false,
    );
  }
} 