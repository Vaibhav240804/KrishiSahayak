import React from 'react';
import CropPredictionForm from '../AgricultureForm';

const Modal = ({ isVisible, onClose, onPredictionUpdate }) => {
  if (!isVisible) return null;

  return (
    <div className='fixed inset-0 bg-black bg-opacity-25 backdrop-blur-sm flex justify-center items-center pt-64 '>
      <div className='w-[600px] flex flex-col text-black'>
        <div className='bg-white p-2 rounded'>
          <CropPredictionForm onPredictionUpdate={onPredictionUpdate} onClose={onClose} />
        </div>

      </div>
    </div>
  );
};

export default Modal;
