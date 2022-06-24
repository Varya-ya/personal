import { FaTimes } from 'react-icons/fa';
import { useContext } from 'react';
import Card from './shared/Card';
import FeedbackContext from '../context/FeedbackContext';

// Setting feedback item structure
function FeedbackItem({ item }) {
    const { deleteFeedback } = useContext(FeedbackContext);

    return (
        <Card>
            <div className='num-display'>{item.rating}</div>
            <button onClick={() => deleteFeedback(item.id)} className='close'>
                <FaTimes color='purple'/>
            </button> 
            <div className='text-display'>{item.text}</div>
        </Card>
        )
}

export default FeedbackItem