import React, { useState } from "react";
import { TextField, Button } from "../vibes";
import { createCategory } from "../services/api";

interface CategoryFormProps {
    onSubmit: () => void;
    onCancel: () => void;
}

export function CategoryForm({
    onSubmit,
    onCancel,
}: CategoryFormProps) {
    const [name, setName] = useState("");
    const [isSubmitting, setIsSubmitting] = useState(false);
    const [errorMessage, setErrorMessage] = useState("");

    const formStyle: React.CSSProperties = {
        display: "flex",
        flexDirection: "column",
        gap: "1rem",
    };

    const buttonGroupStyle: React.CSSProperties = {
        display: "flex",
        gap: "0.5rem",
        marginTop: "0.5rem",
    };

    const errorStyle: React.CSSProperties = {
        color: "#d32f2f",
        backgroundColor: "#fdecea",
        padding: "8px",
        borderRadius: "4px",
    };

    const handleAddCategory = async () => {
        if (!name.trim()) return;

        try {
            setErrorMessage("");
            setIsSubmitting(true);

            await createCategory(name);

            setName("");
            onSubmit();
            onCancel();
        } catch (error) {
            console.error("Failed to create category:", error);

            setErrorMessage("Category already exists.");

        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <div style={formStyle}>
            {errorMessage && (
                <div style={errorStyle}>
                    {errorMessage}
                </div>
            )}
            <TextField
                label="Category Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
            />
            <div style={buttonGroupStyle}>
                <Button
                    onClick={handleAddCategory}
                    disabled={isSubmitting || !name.trim()}>
                    Add Category
                </Button>
                <Button
                    variant="secondary"
                    onClick={onCancel}>
                    Cancel
                </Button>
            </div>
        </div>
    );
}