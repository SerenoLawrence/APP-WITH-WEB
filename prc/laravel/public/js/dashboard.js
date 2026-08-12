/**
 * dashboard.js — CivilWatch Admin
 *
 * Loads dashboard stats from the API and populates the page.
 */

// Guard: redirect to login if not authenticated
requireAuth();

// Populate topbar username
populateTopbar();

// Populate welcome message
const user = getUser();
if (user) {
    const welcomeName = document.getElementById('welcomeName');
    const welcomeRole = document.getElementById('welcomeRole');
    if (welcomeName) welcomeName.textContent = user.name;
    if (welcomeRole) welcomeRole.textContent = formatRole(user.role);
}

// Load stats from API
async function loadStats() {
    try {
        const result = await apiFetch('/dashboard/stats');

        if (result && result.data.success) {
            const stats = result.data.data;
            document.getElementById('statTotal').textContent  = stats.total_users;
            document.getElementById('statActive').textContent = stats.active_users;
            document.getElementById('statAdmins').textContent = stats.admin_count;
        }
    } catch (err) {
        console.error('Failed to load stats:', err);
    }
}

// Format role for display
function formatRole(role) {
    const map = {
        super_admin: 'Super Admin',
        ceo:         'CEO',
        cenro:       'CENRO',
    };
    return map[role] || role;
}

// Run on page load
loadStats();
