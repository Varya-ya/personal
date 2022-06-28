import { createContext, useState, useEffect } from 'react';

const FeedbackContext = createContext();

export const FeedbackProvider = ({ children }) => {
    const [isLoading, setIsLoading] = useState(true);
    const [feedback, setFeedback] = useState([]);

    const [feedbackEdit, setFeedbackEdit] = useState({
        item: {},
        edit: false,
    }); 

    useEffect(() => {
        fetchFeedback()
    }, []);

    const fetchFeedback = async () => {
        const response = await fetch(`/feedback`);
        const data = await response.json()

        setFeedback(data.sort(function (a, b) {
            return b.id - a.id;
        }))
        setIsLoading(false)
    };

    const addFeedback = async (newFeedback) => {
        const response = await fetch('/feedback', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(newFeedback),
        });

        const data = await response.json()

        setFeedback([data, ...feedback])
    };

    const deleteFeedback = async (id) => {
        await fetch(`/feedback/${id}`, {method: 'DELETE'})

        setFeedback(feedback.filter((item) => item.id !== id))
    };

    const updateFeedback = async (id, updItem) => {
        const response = await fetch(`/feedback/${id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(updItem),
        });

        const data = await response.json()

        setFeedback(feedback.map((item) => item.id === id ? { ...item, ...data } : item))

        setFeedbackEdit({
            item: {},
            edit: false,
        })
    };

    const editFeedback = (item) => {
        setFeedbackEdit({
            item,
            edit: true
        })
    };

    return <FeedbackContext.Provider value={{
        feedback,
        deleteFeedback,
        addFeedback,
        editFeedback,
        feedbackEdit, 
        updateFeedback, 
        isLoading
    }}>
        {children}
    </FeedbackContext.Provider>
}

export default FeedbackContext