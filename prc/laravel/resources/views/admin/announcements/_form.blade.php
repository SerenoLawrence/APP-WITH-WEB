<div class="form-group">
    <label>Title *</label>
    <input type="text" name="title" class="form-control" required placeholder="Announcement title">
</div>
<div class="form-group">
    <label>Body *</label>
    <textarea name="body" class="form-control" required placeholder="Announcement content..." rows="4"></textarea>
</div>
<div class="form-group">
    <label>Status</label>
    <select name="is_published" class="form-control">
        <option value="1">Published (visible in app)</option>
        <option value="0">Draft (hidden from app)</option>
    </select>
</div>
