import ClassModel from "../models/ClassModel.js";

export const getTeacherClasses = async (req, res) => {
  try {
    // Return all classes (public view)
    const classes = await ClassModel.find()
      .sort({ createdAt: -1 });
    res.json(classes);
  } catch (err) {
    console.error('Error in getTeacherClasses:', err);
    res.status(500).json({ message: "Failed to fetch classes" });
  }
};

export const createClass = async (req, res) => {
  try {
    const { subject, semester, studentsCount, teacherId } = req.body;
    
    if (!subject || !semester) {
      return res.status(400).json({ message: "Subject and semester are required" });
    }

    const newClass = await ClassModel.create({
      subject,
      semester,
      studentsCount: studentsCount || 0,
      teacher: teacherId
    });

    res.status(201).json(newClass);
  } catch (err) {
    console.error('Error in createClass:', err);
    res.status(500).json({ message: "Failed to create class" });
  }
};

export const setClassLocation = async (req, res) => {
  try {
      const { latitude, longitude } = req.body;
      const classId = req.params.id;
    
      if (!latitude || !longitude) {
        return res.status(400).json({ message: "Latitude and longitude are required" });
    }

    const cls = await ClassModel.findByIdAndUpdate(
      classId,
      { latitude, longitude },
      { new: true }
    );

    if (!cls) {
      return res.status(404).json({ message: "Class not found" });
    }

    res.json(cls);
  } catch (err) {
    console.error('Error in setClassLocation:', err);
    res.status(500).json({ message: "Failed to update class location" });
  }
};
