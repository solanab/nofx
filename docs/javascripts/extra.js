/* NOFX Documentation - Custom JavaScript */

// Version selector (if needed in the future)
document.addEventListener("DOMContentLoaded", function() {
  // Add any custom initialization here

  // Example: Add copy functionality for exchange referral links
  document.querySelectorAll('a[href*="join"], a[href*="referral"]').forEach(function(link) {
    link.setAttribute('target', '_blank');
    link.setAttribute('rel', 'noopener noreferrer');
  });

  // Example: Track outbound links (when analytics is configured)
  if (typeof gtag === 'function') {
    document.querySelectorAll('a[href^="http"]').forEach(function(link) {
      if (!link.href.includes(window.location.hostname)) {
        link.addEventListener('click', function() {
          gtag('event', 'click', {
            'event_category': 'outbound',
            'event_label': link.href
          });
        });
      }
    });
  }
});

// Add keyboard shortcuts for navigation
document.addEventListener("keydown", function(e) {
  // Press '/' to focus search
  if (e.key === '/' && !e.ctrlKey && !e.metaKey && !e.altKey) {
    var searchInput = document.querySelector('.md-search__input');
    if (searchInput && document.activeElement !== searchInput) {
      e.preventDefault();
      searchInput.focus();
    }
  }
});
