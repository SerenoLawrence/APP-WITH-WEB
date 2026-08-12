// ============================================================
// CIVILWATCH Admin Dashboard — Utilities
// ============================================================

const Utils = {

  // Format date string
  formatDate(dateStr) {
    return dateStr || '—';
  },

  // Get status badge HTML
  statusBadge(status) {
    const map = {
      'Pending Validation': { cls: 'badge-validation', icon: 'schedule',      label: 'Pending Validation' },
      'Assigned':           { cls: 'badge-assigned',   icon: 'assignment_ind', label: 'Assigned' },
      'In Progress':        { cls: 'badge-inprogress', icon: 'autorenew',      label: 'In Progress' },
      'Resolved':           { cls: 'badge-resolved',   icon: 'check_circle',   label: 'Resolved' },
    };
    const s = map[status] || { cls: 'badge-pending', icon: 'help', label: status };
    return `<span class="badge ${s.cls}"><span class="material-symbols-outlined">${s.icon}</span>${s.label}</span>`;
  },

  // Get category badge HTML
  categoryBadge(category) {
    if (category === 'Infrastructure') {
      return `<span class="badge-infra"><span class="material-symbols-outlined">construction</span>Infrastructure</span>`;
    }
    return `<span class="badge-env"><span class="material-symbols-outlined">eco</span>Environmental</span>`;
  },

  // Placeholder image for broken/missing photos
  photoPlaceholder() {
    return `<div class="table-photo-placeholder"><span class="material-symbols-outlined">image</span></div>`;
  },

  // Show toast notification
  showToast(message, type = 'info', duration = 3000) {
    let container = document.querySelector('.toast-container');
    if (!container) {
      container = document.createElement('div');
      container.className = 'toast-container';
      document.body.appendChild(container);
    }
    const icons = { success: 'check_circle', error: 'error', info: 'info' };
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `<span class="material-symbols-outlined" style="font-size:18px">${icons[type] || 'info'}</span>${message}`;
    container.appendChild(toast);
    setTimeout(() => {
      toast.style.animation = 'none';
      toast.style.opacity = '0';
      toast.style.transition = 'opacity 0.3s ease';
      setTimeout(() => toast.remove(), 300);
    }, duration);
  },

  // Debounce
  debounce(fn, delay = 300) {
    let t;
    return (...args) => { clearTimeout(t); t = setTimeout(() => fn(...args), delay); };
  },

  // Get URL param
  getParam(name) {
    return new URLSearchParams(window.location.search).get(name);
  },

  // Format relative time
  relativeTime(minutesAgo) {
    if (minutesAgo < 1)   return 'just now';
    if (minutesAgo < 60)  return `${minutesAgo} minutes ago`;
    if (minutesAgo < 120) return '1 hour ago';
    if (minutesAgo < 1440) return `${Math.floor(minutesAgo / 60)} hours ago`;
    return `${Math.floor(minutesAgo / 1440)} days ago`;
  },

  // Highlight search term
  highlight(text, query) {
    if (!query) return text;
    const re = new RegExp(`(${query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
    return text.replace(re, '<mark style="background:#FEF9C3;border-radius:2px">$1</mark>');
  }
};

// ============================================================
// Shared Photo renderer - Real Unsplash images for demo
// ============================================================
const PHOTO_URLS = {
  'damaged-road':     'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=300&fit=crop&q=80',
  'illegal-dumping':  'https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=400&h=300&fit=crop&q=80',
  'damaged-sidewalk': 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400&h=300&fit=crop&q=80',
  'blocked-drainage': 'https://images.unsplash.com/photo-1590845947670-c009801ffa74?w=400&h=300&fit=crop&q=80',
  'overgrown':        'https://images.unsplash.com/photo-1588392382834-a891154bca4d?w=400&h=300&fit=crop&q=80',
  'streetlight':      'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=400&h=300&fit=crop&q=80',
  'broken-bridge':    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop&q=80',
  'soil-erosion':     'https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?w=400&h=300&fit=crop&q=80',
  'road-sign':        'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&h=300&fit=crop&q=80',
};

function getPhotoUrl(issue) {
  const key = (issue || '').toLowerCase().replace(/\s+/g, '-');
  const map = {
    'damaged-road':        PHOTO_URLS['damaged-road'],
    'illegal-dumping':     PHOTO_URLS['illegal-dumping'],
    'damaged-sidewalk':    PHOTO_URLS['damaged-sidewalk'],
    'blocked-drainage':    PHOTO_URLS['blocked-drainage'],
    'overgrown-vegetation':PHOTO_URLS['overgrown'],
    'broken-streetlight':  PHOTO_URLS['streetlight'],
    'soil-erosion':        PHOTO_URLS['soil-erosion'],
    'blocked-canal':       PHOTO_URLS['blocked-drainage'],
    'road-sign-damage':    PHOTO_URLS['road-sign'],
    'damaged-bridge':      PHOTO_URLS['broken-bridge'],
  };
  return map[key] || PHOTO_URLS['damaged-road'];
}

// Full-size version for detail pages (larger images)
function getPhotoUrlLarge(issue) {
  const key = (issue || '').toLowerCase().replace(/\s+/g, '-');
  const map = {
    'damaged-road':        'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800&h=500&fit=crop&q=85',
    'illegal-dumping':     'https://images.unsplash.com/photo-1621451537084-482c73073a0f?w=800&h=500&fit=crop&q=85',
    'damaged-sidewalk':    'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=800&h=500&fit=crop&q=85',
    'blocked-drainage':    'https://images.unsplash.com/photo-1590845947670-c009801ffa74?w=800&h=500&fit=crop&q=85',
    'overgrown-vegetation':'https://images.unsplash.com/photo-1588392382834-a891154bca4d?w=800&h=500&fit=crop&q=85',
    'broken-streetlight':  'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&h=500&fit=crop&q=85',
    'soil-erosion':        'https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?w=800&h=500&fit=crop&q=85',
    'blocked-canal':       'https://images.unsplash.com/photo-1590845947670-c009801ffa74?w=800&h=500&fit=crop&q=85',
    'road-sign-damage':    'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800&h=500&fit=crop&q=85',
    'damaged-bridge':      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=500&fit=crop&q=85',
  };
  return map[key] || 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800&h=500&fit=crop&q=85';
}
