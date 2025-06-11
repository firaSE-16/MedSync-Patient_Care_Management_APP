const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const PrescriptionSchema = new Schema({
    
    patientId: { 
        type: Schema.Types.ObjectId, 
        ref: 'User', 
        required: true 
    },
    doctorId: { 
        type: Schema.Types.ObjectId, 
        ref: 'User',
        required: true 
    },
    medications: [{
        
        name: { type: String },
        dosage: { type: String },
        frequency: { type: String },
        description: { type: String },
        price: { type: Number },
    }],
    
    
});

module.exports = mongoose.model('Prescription', PrescriptionSchema);