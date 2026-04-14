import Notification from "../models/Notification.js";

export const getNotifications = async (req, res) => {
  try {
    // If unauthenticated, return only 'all' notifications. If authenticated, return notifications for user's role and 'all'.
    const role = req.user ? req.user.role : null;
    const query = role ? { $or: [{ role }, { role: 'all' }] } : { role: 'all' };
    const notes = await Notification.find(query).sort({ createdAt: -1 });
    res.json(notes);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const createNotification = async (req, res) => {
  const { message, role } = req.body;
  try {
    const note = await Notification.create({ message, role });
    res.status(201).json(note);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
