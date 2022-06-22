import { motion, AnimatePresence} from 'framer-motion';
import PropTypes from 'prop-types';
import FeedbackItem from './FeedbackItem';

// Show feedback list if there is any feedback item
function FeedbackList({ feedback, handleDelete }) {
    if (!feedback || feedback.length === 0 ) {
        return <p>No Feedback Yet</p>
    }

    // Mapping items to list
    return (
        <div className='feedback-list'>
            <AnimatePresence>
                {feedback.map((item) => (
                    <motion.div
                        key={item.id}
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                    >
                        <FeedbackItem
                            key={item.id}
                            item={item}
                            handleDelete={handleDelete}
                        />
                    </motion.div>
            ))}
            </AnimatePresence>
        </div>
        )
}

FeedbackList.propTypes = {
    feedback: PropTypes.array
}

export default FeedbackList