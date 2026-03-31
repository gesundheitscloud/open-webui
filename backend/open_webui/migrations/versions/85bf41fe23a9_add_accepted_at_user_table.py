"""add accepted_at column to user model

Revision ID: 85bf41fe23a9
Revises: 42e2978c7933
Create Date: 2026-07-21 13:14:57.288648

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
import open_webui.internal.db
from sqlalchemy.dialects import sqlite

# revision identifiers, used by Alembic.
revision: str = '85bf41fe23a9'
down_revision: Union[str, None] = '42e2978c7933'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    conn = op.get_bind()
    inspector = sa.inspect(conn)
    user_columns = {c['name'] for c in inspector.get_columns('user')}

    if "accepted_at" not in user_columns:
        op.add_column('user', sa.Column('accepted_at', sa.BigInteger(), nullable=True))


def downgrade() -> None:
    op.drop_column('user', 'accepted_at')
