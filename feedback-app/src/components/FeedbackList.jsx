import PropTypes from 'prop-types';
import FeedbackItem from './FeedbackItem';

// Show feedback list if there is any feedback item
function FeedbackList({ feedback, handleDelete }) {
    if (!feedback || feedback.length === 0 ) {
        return <p>No Feedback Yet</p>
    }

    // Mapping items to list
    return (
        <div className = 'feedback-list'>
            {feedback.map((item) => (
                <FeedbackItem
                    key={item.id}
                    item={item}
                    handleDelete={handleDelete} />
                ))}
        </div>
        )
}

FeedbackList.propTypes = {
    feedback: PropTypes.array
}

export default FeedbackList