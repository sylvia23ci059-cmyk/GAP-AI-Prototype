CREATE TABLE public.ml_notes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    subject text NOT NULL DEFAULT 'Machine Learning'
        CHECK (subject = 'Machine Learning'),
    file_name text NOT NULL CHECK (length(file_name) BETWEEN 1 AND 180),
    content_type text NOT NULL,
    byte_size integer NOT NULL CHECK (byte_size BETWEEN 1 AND 5242880),
    content bytea NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (octet_length(content) = byte_size)
);

CREATE INDEX ml_notes_created_at_idx
    ON public.ml_notes (created_at DESC);
