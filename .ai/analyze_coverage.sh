#!/bin/bash
# Analyze test coverage by layer

echo "=== TEST COVERAGE ANALYSIS (Epic 2) ==="
echo ""

# Parse coverage file
domain_lf=0
domain_lh=0
data_lf=0
data_lh=0
presentation_lf=0
presentation_lh=0
total_lf=0
total_lh=0

current_file=""
current_lf=0
current_lh=0

while IFS= read -r line; do
    if [[ $line == SF:* ]]; then
        current_file="${line#SF:}"
    elif [[ $line == LF:* ]]; then
        current_lf="${line#LF:}"
        total_lf=$((total_lf + current_lf))
    elif [[ $line == LH:* ]]; then
        current_lh="${line#LH:}"
        total_lh=$((total_lh + current_lh))

        # Categorize by layer
        if [[ $current_file == *"domain"* ]]; then
            domain_lf=$((domain_lf + current_lf))
            domain_lh=$((domain_lh + current_lh))
        elif [[ $current_file == *"data"* ]]; then
            data_lf=$((data_lf + current_lf))
            data_lh=$((data_lh + current_lh))
        elif [[ $current_file == *"presentation"* ]]; then
            presentation_lf=$((presentation_lf + current_lf))
            presentation_lh=$((presentation_lh + current_lh))
        fi
    fi
done < coverage/lcov.info

# Calculate percentages
total_pct=$(awk "BEGIN {printf \"%.1f\", ($total_lh/$total_lf)*100}")
domain_pct=$(awk "BEGIN {printf \"%.1f\", ($domain_lh/$domain_lf)*100}")
data_pct=$(awk "BEGIN {printf \"%.1f\", ($data_lh/$data_lf)*100}")
presentation_pct=$(awk "BEGIN {printf \"%.1f\", ($presentation_lh/$presentation_lf)*100}")

echo "📊 GLOBAL COVERAGE:"
echo "  Total: ${total_pct}% ($total_lh/$total_lf lines)"
echo ""

echo "🎯 BY LAYER:"
if [ $domain_lf -gt 0 ]; then
    status="❌ BELOW TARGET (≥80%)"
    if (( $(echo "$domain_pct >= 80" | bc -l) )); then
        status="✅ TARGET MET (≥80%)"
    fi
    echo "  Domain:       ${domain_pct}% ($domain_lh/$domain_lf lines) $status"
fi

if [ $data_lf -gt 0 ]; then
    status="❌ BELOW TARGET (≥70%)"
    if (( $(echo "$data_pct >= 70" | bc -l) )); then
        status="✅ TARGET MET (≥70%)"
    fi
    echo "  Data:         ${data_pct}% ($data_lh/$data_lf lines) $status"
fi

if [ $presentation_lf -gt 0 ]; then
    status="❌ BELOW TARGET (≥50%)"
    if (( $(echo "$presentation_pct >= 50" | bc -l) )); then
        status="✅ TARGET MET (≥50%)"
    fi
    echo "  Presentation: ${presentation_pct}% ($presentation_lh/$presentation_lf lines) $status"
fi
