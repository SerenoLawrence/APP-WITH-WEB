/**
 * users.js — CivilWatch Admin
 *
 * Handles full User CRUD:
 *  - Load and display users table
 *  - Search users
 *  - Open Add / Edit modal
 *  - Save (create or update) user
 *  - Delete user with confirmation
 */

// Guard: redirect to login if not authenticated
requireAuth();

// Populate topbar username
populateTopbar();

// ----------------------------------------------------------------
// State
// ----------------------------------------------------------------
let currentEditId = null; // null = adding new, number = editing

// ----------------------------------------------------------------
// DOM References
// ----------------------------------------------------------------
const tableBody       = document.getElementById('usersTableBody');
const searchInput     = document.getElementById('searchInput');
const searchBtn       = document.getElementById('searchBtn');
const clearBtn        = document.getElementById('clearBtn');
const addUserBtn      = document.getElementById('addUserBtn');

// User modal
const userModal       = document.getElementById('userModal');
const modalTitle      = document.getElementById('modalTitle');
const modalCloseBtn   = document.getElementById('modalCloseBtn');
const modalCancelBtn  = document.getElementById('modalCancelBtn');
const modalSaveBtn    = document.getElementById('modalSaveBtn');

// Delete modal
const deleteModal     = document.getElementById('deleteModal');
const deleteUserName  = document.getElementById('deleteUserName');
const deleteCloseBtn  = document.getElementById('deleteModalCloseBtn');
const deleteCancelBtn = document.getElementById('deleteCancelBtn');
const deleteConfirmBtn= document.getElementById('deleteConfirmBtn');

// ----------------------------------------------------------------
// Utility: format role for display
// ----------------------------------------------------------------
function formatRole(role) {
    const map = { super_admin: 'Super Admin', ceo: 'CEO', cenro: 'CENRO' };
    return map[role] || role;
}

// ----------------------------------------------------------------
// Utility: render active/inactive badge
// ----------------------------------------------------------------
function statusBadge(isActive) {
    return isActive
        ? '<span class="badge badge-success">Active</span>'
        : '<span class="badge badge-danger">Inactive</span>';
}

// ----------------------------------------------------------------
// Utility: render role badge
// ----------------------------------------------------------------
function roleBadge(role) {
    const classes = {
        super_admin: 'badge-primary',
        ceo:         'badge-warning',
        cenro:       'badge-gray',
    };
    return `<span class="badge ${classes[role] || 'badge-gray'}">${formatRole(role)}</span>`;
}

// ----------------------------------------------------------------
// Load users from API and render table
// ----------------------------------------------------------------
async function loadUsers(search = '') {
    tableBody.innerHTML = `<tr><td colspan="7" class="empty-state">Loading...</td></tr>`;

    const query = search ? `?search=${encodeURIComponent(search)}` : '';

    try {
        const result = await apiFetch(`/users${query}`);

        if (!result || !result.data.success) {
            tableBody.innerHTML = `<tr><td colspan="7" class="empty-state">Failed to load users.</td></tr>`;
            return;
        }

        const users = result.data.data;

        if (users.length === 0) {
            tableBody.innerHTML = `<tr><td colspan="7" class="empty-state">No users found.</td></tr>`;
            return;
        }

        tableBody.innerHTML = users.map(user => `
            <tr>
                <td>${user.id}</td>
                <td><strong>${escapeHtml(user.name)}</strong></td>
                <td>${escapeHtml(user.email)}</td>
                <td>${roleBadge(user.role)}</td>
                <td>${user.office ? escapeHtml(user.office) : '<span style="color:var(--gray-400)">—</span>'}</td>
                <td>${statusBadge(user.is_active)}</td>
                <td>
                    <div class="actions">
                        <button class="btn btn-outline btn-sm" onclick="openEditModal(${user.id})">Edit</button>
                        <button class="btn btn-danger btn-sm"  onclick="openDeleteModal(${user.id}, '${escapeHtml(user.name)}')">Delete</button>
                    </div>
                </td>
            </tr>
        `).join('');

    } catch (err) {
        tableBody.innerHTML = `<tr><td colspan="7" class="empty-state">Network error.</td></tr>`;
    }
}

// ----------------------------------------------------------------
// Escape HTML to prevent XSS
// ----------------------------------------------------------------
function escapeHtml(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

// ----------------------------------------------------------------
// Search
// ----------------------------------------------------------------
searchBtn.addEventListener('click', () => {
    loadUsers(searchInput.value.trim());
});

searchInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') loadUsers(searchInput.value.trim());
});

clearBtn.addEventListener('click', () => {
    searchInput.value = '';
    loadUsers();
});

// ----------------------------------------------------------------
// Modal helpers
// ----------------------------------------------------------------
function openModal() {
    userModal.classList.add('open');
}

function closeModal() {
    userModal.classList.remove('open');
    clearModalForm();
}

function clearModalForm() {
    currentEditId = null;
    document.getElementById('userId').value       = '';
    document.getElementById('userName').value     = '';
    document.getElementById('userEmail').value    = '';
    document.getElementById('userPassword').value = '';
    document.getElementById('userRole').value     = '';
    document.getElementById('userOffice').value   = '';
    document.getElementById('userStatus').value   = '1';

    // Reset password field label
    document.getElementById('passwordRequired').style.display = 'inline';
    document.getElementById('passwordHint').style.display     = 'none';

    // Clear errors
    hideAlert('modalError');
    clearFieldErrors([
        { fieldId: 'userName',     errorId: 'userNameError'     },
        { fieldId: 'userEmail',    errorId: 'userEmailError'    },
        { fieldId: 'userPassword', errorId: 'userPasswordError' },
        { fieldId: 'userRole',     errorId: 'userRoleError'     },
    ]);
}

// ----------------------------------------------------------------
// Open ADD modal
// ----------------------------------------------------------------
addUserBtn.addEventListener('click', () => {
    clearModalForm();
    modalTitle.textContent = 'Add User';
    openModal();
});

// ----------------------------------------------------------------
// Open EDIT modal — fetch user data then populate form
// ----------------------------------------------------------------
async function openEditModal(id) {
    clearModalForm();
    modalTitle.textContent = 'Edit User';
    currentEditId = id;

    try {
        const result = await apiFetch(`/users/${id}`);

        if (!result || !result.data.success) {
            showAlert('errorAlert', 'Could not load user data.', 'error');
            return;
        }

        const u = result.data.data;
        document.getElementById('userId').value    = u.id;
        document.getElementById('userName').value  = u.name;
        document.getElementById('userEmail').value = u.email;
        document.getElementById('userRole').value  = u.role;
        document.getElementById('userOffice').value= u.office || '';
        document.getElementById('userStatus').value= u.is_active ? '1' : '0';

        // Password is optional when editing
        document.getElementById('passwordRequired').style.display = 'none';
        document.getElementById('passwordHint').style.display     = 'inline';

        openModal();

    } catch (err) {
        showAlert('errorAlert', 'Network error loading user.', 'error');
    }
}

// Make accessible globally (called from onclick in table)
window.openEditModal = openEditModal;

// ----------------------------------------------------------------
// Save user (create or update)
// ----------------------------------------------------------------
modalSaveBtn.addEventListener('click', async () => {
    hideAlert('modalError');

    // Clear previous field errors
    clearFieldErrors([
        { fieldId: 'userName',     errorId: 'userNameError'     },
        { fieldId: 'userEmail',    errorId: 'userEmailError'    },
        { fieldId: 'userPassword', errorId: 'userPasswordError' },
        { fieldId: 'userRole',     errorId: 'userRoleError'     },
    ]);

    const name     = document.getElementById('userName').value.trim();
    const email    = document.getElementById('userEmail').value.trim();
    const password = document.getElementById('userPassword').value;
    const role     = document.getElementById('userRole').value;
    const office   = document.getElementById('userOffice').value.trim();
    const isActive = document.getElementById('userStatus').value === '1';

    // Client-side validation
    let hasError = false;

    if (!name) {
        setFieldError('userName', 'userNameError', 'Name is required.');
        hasError = true;
    }
    if (!email) {
        setFieldError('userEmail', 'userEmailError', 'Email is required.');
        hasError = true;
    }
    if (!currentEditId && !password) {
        setFieldError('userPassword', 'userPasswordError', 'Password is required for new users.');
        hasError = true;
    }
    if (!role) {
        setFieldError('userRole', 'userRoleError', 'Please select a role.');
        hasError = true;
    }

    if (hasError) return;

    // Build payload
    const payload = { name, email, role, office, is_active: isActive };
    if (password) payload.password = password;

    modalSaveBtn.disabled = true;
    modalSaveBtn.textContent = 'Saving...';

    try {
        const isEditing = !!currentEditId;
        const result = await apiFetch(
            isEditing ? `/users/${currentEditId}` : '/users',
            {
                method: isEditing ? 'PUT' : 'POST',
                body:   JSON.stringify(payload),
            }
        );

        if (result.data.success) {
            closeModal();
            showAlert('successAlert', result.data.message, 'success');
            loadUsers(searchInput.value.trim());

            // Auto-hide success message after 3 seconds
            setTimeout(() => hideAlert('successAlert'), 3000);

        } else {
            // Show server validation errors if any
            if (result.data.errors) {
                const errors = result.data.errors;
                if (errors.name)     setFieldError('userName',     'userNameError',     errors.name[0]);
                if (errors.email)    setFieldError('userEmail',    'userEmailError',    errors.email[0]);
                if (errors.password) setFieldError('userPassword', 'userPasswordError', errors.password[0]);
                if (errors.role)     setFieldError('userRole',     'userRoleError',     errors.role[0]);
            } else {
                showAlert('modalError', result.data.message || 'Failed to save user.', 'error');
            }
        }

    } catch (err) {
        showAlert('modalError', 'Network error. Please try again.', 'error');
    } finally {
        modalSaveBtn.disabled = false;
        modalSaveBtn.textContent = 'Save User';
    }
});

// ----------------------------------------------------------------
// Delete modal
// ----------------------------------------------------------------
let deleteTargetId = null;

function openDeleteModal(id, name) {
    deleteTargetId = id;
    deleteUserName.textContent = name;
    deleteModal.classList.add('open');
}

// Make accessible globally (called from onclick in table)
window.openDeleteModal = openDeleteModal;

function closeDeleteModal() {
    deleteTargetId = null;
    deleteModal.classList.remove('open');
}

deleteConfirmBtn.addEventListener('click', async () => {
    if (!deleteTargetId) return;

    deleteConfirmBtn.disabled = true;
    deleteConfirmBtn.textContent = 'Deleting...';

    try {
        const result = await apiFetch(`/users/${deleteTargetId}`, { method: 'DELETE' });

        if (result.data.success) {
            closeDeleteModal();
            showAlert('successAlert', result.data.message, 'success');
            loadUsers(searchInput.value.trim());
            setTimeout(() => hideAlert('successAlert'), 3000);
        } else {
            closeDeleteModal();
            showAlert('errorAlert', result.data.message || 'Failed to delete user.', 'error');
        }

    } catch (err) {
        closeDeleteModal();
        showAlert('errorAlert', 'Network error.', 'error');
    } finally {
        deleteConfirmBtn.disabled = false;
        deleteConfirmBtn.textContent = 'Delete';
    }
});

// ----------------------------------------------------------------
// Close modal events
// ----------------------------------------------------------------
modalCloseBtn.addEventListener('click',  closeModal);
modalCancelBtn.addEventListener('click', closeModal);
deleteCloseBtn.addEventListener('click',  closeDeleteModal);
deleteCancelBtn.addEventListener('click', closeDeleteModal);

// Close modal if user clicks the dark overlay background
userModal.addEventListener('click', (e) => { if (e.target === userModal)  closeModal(); });
deleteModal.addEventListener('click', (e) => { if (e.target === deleteModal) closeDeleteModal(); });

// ----------------------------------------------------------------
// Initial load
// ----------------------------------------------------------------
loadUsers();
